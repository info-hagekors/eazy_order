
import 'package:eazy_order_admin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class FirebaseNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static late final String token;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint("🔥 Firebase Initialized Successfully!");
    } catch (e) {
      debugPrint("🚨 Firebase Initialization Error: $e");
    }

    // Request permissions
    /*NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("User granted permission for notifications");
    } else {
      debugPrint("User declined or has not accepted notification permissions");
    }

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Received foreground notification: ${message.notification?.title}");
      showNotification(message);
    });

    // Handle background notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification clicked: ${message.data}");
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize local notifications
    _initializeLocalNotifications();

    //Get the token
    await getToken();*/
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint("Handling background notification: ${message.notification?.title}");
  }

  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _localNotificationsPlugin.initialize(settings);

    final plugin = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await plugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  ///ToDo::: Make it private once api integration completed
  static Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'jiinue_core_01', // Channel ID
      'Jiinue Notifications', // Channel Name
      importance: Importance.max,
      icon: '@mipmap/ic_launcher',
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
      presentList: true
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await _localNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'Jiinue',
      message.notification?.body ?? '---',
      notificationDetails,
    );
  }

  static Future<String?> getToken() async {
    token = await _firebaseMessaging.getToken() ?? '';
    return token;
  }
}
