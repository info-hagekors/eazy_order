
const functions = require("firebase-functions");
const axios = require("axios");
const admin = require("firebase-admin");
const Razorpay = require("razorpay");
const cors = require("cors")({ origin: true });
require("dotenv").config();

admin.initializeApp();

exports.sendOtp = functions.https.onCall(async (data, context) => {
  const { mobile } = data;

  if (!mobile) {
    throw new functions.https.HttpsError('invalid-argument', 'Mobile number is required.');
  }

  return { success: true, data: {'otp': '15253'} };

  const url = `https://api.msg91.com/api/v5/otp`;

  try {
    const response = await axios.post(url, {
      mobile: `91${mobile}`, // change as per your country code
      //authkey: process.env.MSG91_AUTH_KEY,
      //sender: process.env.SENDER_ID,
      otp_length: 5,
      otp_expiry: 5,
    });

    return { success: true, data: response.data };
  } catch (error) {
    console.error('Send OTP error:', error.response?.data || error.message);
    throw new functions.https.HttpsError('internal', 'Failed to send OTP.');
  }
});

exports.verifyOtp = functions.https.onCall(async (data, context) => {
  const { mobile, otp } = data;

  if (!mobile || !otp) {
    throw new functions.https.HttpsError('invalid-argument', 'Mobile number and OTP are required.');
  }

  if (otp == '15253') {
    return { success: true };
  } else {
    throw new Error('OTP verification failed');
  }

  const url = `https://api.msg91.com/api/v5/otp/verify`;

  try {
    const response = await axios.get(url, {
      params: {
        //authkey: process.env.MSG91_AUTH_KEY,
        mobile: `91${mobile}`,
        otp,
      }
    });

    const type = response.data?.type;

    if (type === 'success') {
      return { success: true };
    } else {
      throw new Error('OTP verification failed');
    }

  } catch (error) {
    console.error('Verify OTP error:', error.response?.data || error.message);
    throw new functions.https.HttpsError('internal', 'OTP verification failed.');
  }
});

const razorpay = new Razorpay({
  key_id: functions.config().razorpay.key_id,
  key_secret: functions.config().razorpay.key_secret,
});

exports.createRazorpayOrderApi = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") {
      return res.status(405).send({ error: "Method Not Allowed" });
    }

    const { amount, currency = "INR", receipt } = req.body;

    if (!amount || !receipt) {
      return res.status(400).send({ error: "Amount and receipt are required" });
    }

    try {
      const order = await razorpay.orders.create({
        amount: amount * 100, // Convert to paise
        currency,
        receipt,
      });

      res.status(200).send({ success: true, order });
    } catch (error) {
      console.error("Razorpay Order Error:", error);
      res.status(500).send({ success: false, message: "Order creation failed" });
    }
  });
});

exports.notifyBusinessOnOrderApi = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    if (req.method !== "POST") {
      return res.status(405).send({ error: "Method Not Allowed" });
    }

    const { orderId, orderNumber, customerName, token, amount } = req.body;

    if (!orderId || !token || !customerName || !amount) {
      return res.status(400).send({ success: false, message: 'Missing required data' });
    }

    const payload = {
      notification: {
        title: `${customerName} has Placed New Order!`,
        body: `(${orderNumber}) order is placed of Rs ${amount}`,
      },
      data: {
        orderId: orderId.toString(),
      },
      token,
    };

    try {
      await admin.messaging().send(payload);
      return res.status(200).send({ success: true });
    } catch (error) {
      console.error("FCM Send Error:", error);
      return res.status(500).send({ success: false, message: 'Notification failed to send' });
    }
  });
});

// Replace with your actual MSG91 auth key and template details
const MSG91_AUTH_KEY = "454320AkhphNlc686bcae8P1";
const MSG91_API_URL = "https://api.msg91.com/api/v5/whatsapp/whatsapp-outbound-message/bulk/";
const INTEGRATED_NUMBER = "917359505202";
const TEMPLATE_NAMESPACE = "345ed580_9c81_4d1f_a787_f94e01999a39";
const TEMPLATE_NAME = "order_placed_confirmation";

exports.sendWhatsappOrderConfirmationMessage = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
  try {
      const {
        phoneNumber,      // e.g., '919876543210'
        customerName,     // e.g., 'Rahul'
        businessName,     // e.g., 'Rahul Store'
        orderNumber,      // e.g., '#EZ12345'
        orderDate,        // e.g., '07 July 2025'
        orderTotal,       // e.g., '₹475'
        orderUrl          // e.g., 'EZ12345'
      } = req.body;

      //console.log("🔥 Received Params:", req.body);

      if (!phoneNumber || !customerName || !businessName || !orderNumber || !orderDate || !orderTotal) {
        return res.status(400).json({ success: false, error: "Missing required parameters." });
      }

      const payload = {
        integrated_number: INTEGRATED_NUMBER,
        content_type: "template",
        payload: {
          messaging_product: "whatsapp",
          type: "template",
          template: {
            name: TEMPLATE_NAME,
            language: {
              code: "en_GB",
              policy: "deterministic"
            },
            namespace: TEMPLATE_NAMESPACE,
            to_and_components: [
              {
                to: [phoneNumber],
                components: {
                  body_1: {
                    type: "text",
                    value: customerName
                  },
                  body_2: {
                    type: "text",
                    value: businessName
                  },
                  body_3: {
                    type: "text",
                    value: orderNumber
                  },
                  body_4: {
                    type: "text",
                    value: orderDate
                  },
                  body_5: {
                    type: "text",
                    value: orderTotal
                  },
                  button_1: {
                    subtype: "url",
                    type: "text",
                    value: orderUrl
                  }
                }
              }
            ]
          }
        }
      };

      //console.log("📦 Sending Payload to MSG91:", payload);

      const response = await axios.post(MSG91_API_URL, payload, {
        headers: {
          "Content-Type": "application/json",
          "authkey": MSG91_AUTH_KEY
        }
      });

      //console.log("✅ MSG91 Response:", response.data);
      return res.status(200).json({ success: true, data: response.data });

    } catch (error) {
      console.error("❌ WhatsApp send error:", error.response?.data || error.message);
      return res.status(500).json({
        success: false,
        error: error.response?.data || error.message
      });
    }
  });
});


//---------------------------------------------------------
const { DateTime } = require('luxon'); // Import Luxon for timezone handling

const db = admin.firestore();

// --- Configuration Constants ---
// Fixed reporting day start hour: 02:00 AM (IST)
const REPORTING_DAY_START_HOUR = 2; // 2 AM
// Timezone for all calculations: Asia/Kolkata (IST, UTC+5:30)
const RESTAURANT_TIMEZONE = 'Asia/Kolkata';

/**
 * Cloud Function triggered on new order creation.
 * Aggregates order data into the daily report document.
 * This version uses a fixed reporting day start hour (02:00 AM IST) and
 * considers the 'Asia/Kolkata' timezone for all date calculations.
 */
exports.aggregateOrderToDailyReport = functions.firestore
    .document('orders/{order_id}')
    .onCreate(async (snapshot, context) => {
        const orderData = snapshot.data();
        const orderId = context.params.orderId; // Get the ID of the new order document

        if (!orderData) {
            console.warn(`No data found for order ${orderId}. Skipping aggregation.`);
            return null;
        }

        // Extract order details
        // Ensure order_timestamp is converted from Firestore Timestamp to JavaScript Date
        //const orderTimestamp = orderData.created_at ? orderData.created_at.toDate() : new Date();
        let orderTimestamp;
        if (typeof orderData.created_at === 'string') {
            orderTimestamp = DateTime.fromISO(orderData.created_at, { zone: 'utc' }).toJSDate();
            if (!orderTimestamp || isNaN(orderTimestamp.getTime())) {
                console.error(`Invalid ISO 8601 timestamp string for order ${orderId}: ${orderData.created_at}`);
                return null;
            }
        }
        // ... and also update the else if condition if needed
        else if (orderData.created_at instanceof admin.firestore.Timestamp) {
            orderTimestamp = orderData.created_at.toDate();
        }
        const totalAmount = orderData.order_total || 0;
        const paymentMethod = orderData.payment_type || 'Unknown';
        const orderItems = orderData.items || [];
        const fulfillmentTimeMinutes = 0;

        // 1. Determine the reporting date (YYYY-MM-DD) string based on fixed cut-off and timezone
        const reportingDateString = getReportingDate(orderTimestamp, REPORTING_DAY_START_HOUR, RESTAURANT_TIMEZONE);
        const reportRef = db.collection('reports').doc(reportingDateString);

        try {
            // 2. Perform atomic update using a Firestore transaction
            await db.runTransaction(async (transaction) => {
                const reportDoc = await transaction.get(reportRef);
                // Initialize report data or load existing
                const currentReport = reportDoc.data() || {
                    date: reportingDateString,
                    total_sales: 0,
                    total_orders: 0,
                    top_3_items: [],
                    top_3_items_revenue: 0,
                    top_3_items_orders: 0,
                    top_payment_method: { method: null, revenue: 0 },
                    bottom_3_items: [],
                    top_3_categories: [],
                    top_3_categories_revenue: 0,
                    top_3_categories_orders: 0,
                    avg_fulfillment_time: 0,
                    _total_fulfillment_time: 0, // Internal helper for calculating average
                    _item_summary: {}, // Internal map to store all item aggregates
                    _category_summary: {}, // Internal map to store all category aggregates
                    _payment_method_summary: {}, // Internal map to store all payment method aggregates
                    created_at: admin.firestore.FieldValue.serverTimestamp(),
                };

                let reportToUpdate = currentReport;

                // ----------------------------------------------------
                // Update basic metrics
                // ----------------------------------------------------
                reportToUpdate.total_sales += totalAmount;
                reportToUpdate.total_orders += 1;
                reportToUpdate.updated_at = admin.firestore.FieldValue.serverTimestamp();

                // Aggregate fulfillment time
                reportToUpdate._total_fulfillment_time = (reportToUpdate._total_fulfillment_time || 0) + fulfillmentTimeMinutes;
                reportToUpdate.avg_fulfillment_time = reportToUpdate.total_orders > 0
                    ? reportToUpdate._total_fulfillment_time / reportToUpdate.total_orders
                    : 0;

                // ----------------------------------------------------
                // Aggregate items and categories (in-memory processing)
                // ----------------------------------------------------
                const itemAggregates = reportToUpdate._item_summary;
                const categoryAggregates = reportToUpdate._category_summary;
                const paymentMethodAggregates = reportToUpdate._payment_method_summary;

                // Process items from the new order
                orderItems.forEach(item => {
                    const itemName = item.product_name;
                    const itemQuantity = item.quantity || 1;
                    const itemPrice = item.price || 0;
                    const itemCategory = item.category_name || 'Uncategorized';

                    // Update item aggregates
                    if (!itemAggregates[itemName]) {
                        itemAggregates[itemName] = { orders: 0, revenue: 0 };
                    }
                    itemAggregates[itemName].orders += itemQuantity;
                    itemAggregates[itemName].revenue += itemPrice * itemQuantity;

                    // Update category aggregates
                    if (!categoryAggregates[itemCategory]) {
                        categoryAggregates[itemCategory] = { orders: 0, revenue: 0 };
                    }
                    categoryAggregates[itemCategory].orders += itemQuantity;
                    categoryAggregates[itemCategory].revenue += itemPrice * itemQuantity;
                });

                // Update payment method aggregates
                paymentMethodAggregates[paymentMethod] = (paymentMethodAggregates[paymentMethod] || 0) + totalAmount;


                // Convert maps to sorted arrays for top/bottom lists
                const sortedItems = Object.entries(itemAggregates)
                    .map(([name, data]) => ({ name, orders: data.orders, revenue: data.revenue }))
                    .sort((a, b) => b.revenue - a.revenue); // Sort by revenue descending

                const sortedCategories = Object.entries(categoryAggregates)
                    .map(([name, data]) => ({ name, orders: data.orders, revenue: data.revenue }))
                    .sort((a, b) => b.revenue - a.revenue); // Sort by revenue descending

                const sortedPaymentMethods = Object.entries(paymentMethodAggregates)
                    .map(([method, revenue]) => ({ method, revenue }))
                    .sort((a, b) => b.revenue - a.revenue); // Sort by revenue descending


                // ----------------------------------------------------
                // Update the report document fields with derived lists
                // ----------------------------------------------------
                reportToUpdate.top_3_items = sortedItems.slice(0, 3);
                reportToUpdate.top_3_items_revenue = reportToUpdate.top_3_items.reduce((sum, item) => sum + item.revenue, 0);
                reportToUpdate.top_3_items_orders = reportToUpdate.top_3_items.reduce((sum, item) => sum + item.orders, 0);

                // For bottom 3, take the last 3 elements and reverse them to appear in ascending order of revenue
                reportToUpdate.bottom_3_items = sortedItems.slice(-3).sort((a, b) => a.revenue - b.revenue);


                reportToUpdate.top_3_categories = sortedCategories.slice(0, 3);
                reportToUpdate.top_3_categories_revenue = reportToUpdate.top_3_categories.reduce((sum, cat) => sum + cat.revenue, 0);
                reportToUpdate.top_3_categories_orders = reportToUpdate.top_3_categories.reduce((sum, cat) => sum + cat.orders, 0);

                reportToUpdate.top_payment_method = sortedPaymentMethods.length > 0
                    ? sortedPaymentMethods[0]
                    : { method: null, revenue: 0 };

                // Store full aggregates internally (for next transaction to build upon)
                reportToUpdate._item_summary = itemAggregates;
                reportToUpdate._category_summary = categoryAggregates;
                reportToUpdate._payment_method_summary = paymentMethodAggregates;


                // Commit the updated report document
                // merge: true is crucial here, as it will create the document if it doesn't exist
                // or update only the specified fields without overwriting the entire document.
                transaction.set(reportRef, reportToUpdate, { merge: true });
            });

            console.log(`Report for ${reportingDateString} updated successfully for order ${orderId}`);
            return null; // Function completed successfully

        } catch (error) {
            console.error(`Error aggregating order ${orderId}:`, error);
            // Re-throw the error to indicate failure (Cloud Functions will log this)
            throw new Error(`Failed to aggregate order: ${error}`);
        }
    });

/**
 * Calculates the reporting date (YYYY-MM-DD) based on order timestamp,
 * a custom cut-off hour, and a specific timezone.
 *
 * @param {Date} orderTimestamp - The actual timestamp of the order (UTC Date object from Firestore).
 * @param {number} reportingDayStartHour - The hour (0-23) when the reporting day starts in the specified timezone.
 * @param {string} timezone - The IANA timezone string (e.g., 'Asia/Kolkata').
 * @returns {string} The formatted reporting date string (YYYY-MM-DD).
 */
function getReportingDate(orderTimestamp, reportingDayStartHour, timezone) {
    // Create a Luxon DateTime object from the UTC orderTimestamp,
    // and then set its timezone to the specified timezone.
    const orderDateTimeInRestaurantTimezone = DateTime.fromJSDate(orderTimestamp, { zone: 'utc' })
        .setZone(timezone);

    let reportDateTime = orderDateTimeInRestaurantTimezone;

    // If the effective hour in the restaurant's timezone is before the cut-off hour,
    // the report belongs to the previous calendar day.
    if (orderDateTimeInRestaurantTimezone.hour < reportingDayStartHour) {
        reportDateTime = orderDateTimeInRestaurantTimezone.minus({ days: 1 });
    }

    // Format the date to YYYY-MM-DD
    return reportDateTime.toFormat('yyyy-MM-dd');
}








