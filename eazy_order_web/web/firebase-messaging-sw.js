// web/firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/10.11.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.11.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyDJo6RFfvb0yLQ9O7b7hMURFw3xXVusZ-w',
  appId: '1:651913327335:web:d4098b3140c4c3decaa842',
  messagingSenderId: '651913327335',
  projectId: 'eazy-order-fcb5b',
  authDomain: 'eazy-order-fcb5b.firebaseapp.com',
  storageBucket: 'eazy-order-fcb5b.firebasestorage.app',
  measurementId: 'G-YY6S94CKJ6',
});

const messaging = firebase.messaging();
