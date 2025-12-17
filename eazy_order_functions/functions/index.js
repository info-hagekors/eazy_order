// ===============================
// Firebase Functions v2 Setup
// ===============================

const { onRequest } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { logger } = require("firebase-functions");
//const { onUserUpdated } = require("firebase-functions/v2/auth");
//const { auth } = require("firebase-functions");
const { auth } = require("firebase-functions/v1/auth");

const axios = require("axios");
//const functions = require("firebase-functions");
const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const Razorpay = require("razorpay");
const cors = require("cors")
const { DateTime } = require("luxon");
const express = require("express");

admin.initializeApp();
const db = admin.firestore();

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

// ===============================
// Razorpay Configuration
// ===============================

const razorpay = new Razorpay({
  key_id: "rzp_test_AIOvYGTldO3R2v",
  key_secret: "aUK98uEKTIJ5bZmw9qziOiDU",
});

// ===============================
// Razorpay Order API
// ===============================

exports.createRazorpayOrderApiV2 = onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      if (req.method !== "POST") {
        return res.status(405).json({ error: "Method Not Allowed" });
      }

      const { amount, currency = "INR", receipt } = req.body;

      if (!amount || !receipt) {
        return res.status(400).json({ error: "Amount and receipt required" });
      }

      const order = await razorpay.orders.create({
        amount: amount * 100,
        currency,
        receipt,
      });

      return res.json({ success: true, order });

    } catch (error) {
      logger.error("Razorpay Error:", error);
      return res.status(500).json({ success: false });
    }
  });
});


// ===============================
// FCM Notification API
// ===============================

exports.notifyBusinessOnOrderApiV2 = onRequest((req, res) => {
  cors(req, res, async () => {
    try {

      if (req.method !== "POST") {
        return res.status(405).send({ error: "Method Not Allowed" });
      }

      const { orderId, orderNumber, customerName, token, amount } = req.body;

      if (!orderId || !token || !customerName || !amount) {
        return res.status(400).json({ success: false });
      }

      const payload = {
        notification: {
          title: `${customerName} placed new order`,
          body: `(${orderNumber}) ₹${amount}`,
        },
        token,
        data: { orderId: orderId.toString() }
      };

      await admin.messaging().send(payload);

      return res.json({ success: true });

    } catch (error) {
      logger.error("FCM Error:", error);
      return res.status(500).json({ success: false });
    }
  });
});


// ===============================
// WhatsApp MSG91 Configuration
// ===============================

const MSG91_AUTH_KEY = "454320AkhphNlc686bcae8P1";
const MSG91_API_URL = "https://api.msg91.com/api/v5/whatsapp/whatsapp-outbound-message/bulk/";
const INTEGRATED_NUMBER = "917359505202";
const TEMPLATE_NAMESPACE = "345ed580_9c81_4d1f_a787_f94e01999a39";
const TEMPLATE_NAME = "order_placed_confirmation";


// ===============================
// WhatsApp Message API
// ===============================

exports.sendWhatsappOrderConfirmationMessageV2 = onRequest((req, res) => {
  cors(req, res, async () => {

    try {

      const {
        phoneNumber,
        customerName,
        businessName,
        orderNumber,
        orderDate,
        orderTotal,
        orderUrl
      } = req.body;

      if (!phoneNumber || !customerName || !businessName || !orderNumber) {
        return res.status(400).json({ success: false });
      }

      const payload = {
        integrated_number: INTEGRATED_NUMBER,
        content_type: "template",
        payload: {
          messaging_product: "whatsapp",
          type: "template",
          template: {
            name: TEMPLATE_NAME,
            language: { code: "en_GB" },
            namespace: TEMPLATE_NAMESPACE,
            to_and_components: [
              {
                to: [phoneNumber],
                components: {
                  body_1: { type: "text", value: customerName },
                  body_2: { type: "text", value: businessName },
                  body_3: { type: "text", value: orderNumber },
                  body_4: { type: "text", value: orderDate },
                  body_5: { type: "text", value: orderTotal },
                  button_1: { subtype: "url", type: "text", value: orderUrl }
                }
              }
            ]
          }
        }
      };

      const response = await axios.post(MSG91_API_URL, payload, {
        headers: {
          "Content-Type": "application/json",
          "authkey": MSG91_AUTH_KEY
        }
      });

      return res.json({ success: true, data: response.data });

    } catch (error) {
      logger.error("MSG91 Error:", error.response?.data || error.message);
      return res.status(500).json({ success: false });
    }
  });
});


// ===============================
// Firestore Aggregation Trigger
// ===============================

const REPORTING_DAY_START_HOUR = 2;
const RESTAURANT_TIMEZONE = "Asia/Kolkata";

exports.aggregateOrderToDailyReportV2 = onDocumentCreated(
  "orders/{orderId}",
  async (event) => {

    const snapshot = event.data;
    if (!snapshot) return;

    const orderData = snapshot.data();
    const orderId = event.params.orderId;

    let orderTimestamp;

    if (typeof orderData.created_at === "string") {
      orderTimestamp = DateTime.fromISO(orderData.created_at).toJSDate();
    } else {
      orderTimestamp = orderData.created_at.toDate();
    }

    const reportingDate = getReportingDate(
      orderTimestamp,
      REPORTING_DAY_START_HOUR,
      RESTAURANT_TIMEZONE
    );

    const reportRef = db.collection("reports").doc(reportingDate);

    await db.runTransaction(async (tx) => {

      const doc = await tx.get(reportRef);

      const report = doc.exists ? doc.data() : {
        date: reportingDate,
        total_sales: 0,
        total_orders: 0,
        _item_summary: {},
        _category_summary: {},
        _payment_method_summary: {}
      };

      report.total_sales += orderData.order_total || 0;
      report.total_orders += 1;

      tx.set(reportRef, report, { merge: true });
    });

    logger.info(`Aggregated order ${orderId}`);
  }
);

// ===============================
// Create User Api
// ===============================

app.post("/createUser", async (req, res) => {
  const { name, email, phone, role } = req.body;

  if (!email || !phone || !role) {
    return res.status(400).json({ error: "Missing parameters" });
  }

  try {
    const user = await admin.auth().createUser({ email });
    await admin.auth().setCustomUserClaims(user.uid, { role });
    const resetLink = await admin.auth().generatePasswordResetLink(email);

    res.json({
      message: "User created successfully",
      uid: user.uid,
      reset_link: resetLink,
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});
exports.api = onRequest({ region: "us-central1" }, app);


// ===============================
// Send Email Api
// ===============================

app.post("/sendEmail", async (req, res) => {
  const { to, subject, html } = req.body;

  if (!to || !subject || !html) {
    return res.status(400).json({ error: "Missing parameters" });
  }

  try {
    const apiKey = functions.config().msg91.key;

    const response = await axios.post(
      "https://api.msg91.com/api/v5/email/send",
      {
        to: [to],
        subject,
        html,
        from: {
          email: "noreply@yourdomain.com",
          name: "Eazy Order"
        }
      },
      {
        headers: {
          "Authkey": apiKey,
          "Content-Type": "application/json"
        }
      }
    );

    res.json({
      message: "Email sent successfully",
      data: response.data
    });

  } catch (error) {
    console.error("Email Error:", error.response?.data || error.message);
    res.status(500).json({
      error: "Failed to send email",
      details: error.response?.data
    });
  }
});
exports.api = onRequest({ region: "us-central1" }, app);

// ===============================
// Send Otp Api
// ===============================

app.post("/sendOtp", async (req, res) => {
  const { mobile } = req.body;

  if (!mobile) {
    return res.status(400).json({ error: "Missing parameters" });
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
exports.api = onRequest({ region: "us-central1" }, app);

// ===============================
// Verify Otp Api
// ===============================

app.post("/verifyOtp", async (req, res) => {
  const { mobile, otp } = req.body;

  if (!mobile || !otp) {
    return res.status(400).json({ error: "Missing parameters" });
  }


  if (otp == '15253') {
    return { success: true };
  } else {
    return res.status(500).json({ error: "Otp verification failed." });
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
exports.api = onRequest({ region: "us-central1" }, app);

// ===============================
// User Update Trigger (Detect when password is set or changed)
// ===============================

exports.onAuthUserUpdated = functions.auth.user().onUpdate(async (change) => {
  const before = change.before;
  const after = change.after;
  const uid = after.uid;

  const userRef = admin.firestore().collection("users").doc(uid);
  const snap = await userRef.get();
  if (!snap.exists) return;

  const data = snap.data();

  if (data.password_set === true) return;

  if (before.metadata.lastSignInTime === after.metadata.lastSignInTime) return;

  const hasPasswordProvider = after.providerData
    .some(p => p.providerId === "password");

  if (!hasPasswordProvider) return;

  await admin.firestore().collection("users").doc(uid).update({
    email_verified: true,
    password_set: true,
    password_set_at: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  console.log(`Password setup confirmed for user ${uid}`);
});

// ===============================
// Helper Function
// ===============================

function getReportingDate(orderTimestamp, hour, timezone) {
  const dt = DateTime.fromJSDate(orderTimestamp, { zone: "utc" }).setZone(timezone);
  return (dt.hour < hour ? dt.minus({ days: 1 }) : dt).toISODate();
}
