/*  web/firebase-messaging-sw.js  */

importScripts(
  "https://www.gstatic.com/firebasejs/10.12.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/10.12.0/firebase-messaging-compat.js"
);

// Copy-paste the WEB section from lib/firebase_options.dart ↓
firebase.initializeApp({
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_PROJECT_ID.appspot.com",
  messagingSenderId: "22303843381",
  appId: "1:22303843381:web:814ea168d360fddff23d7c",
});

// Initialise Messaging
const messaging = firebase.messaging();

// (Optional) background-notification handler:
// self.addEventListener('push', (event) => { … });
