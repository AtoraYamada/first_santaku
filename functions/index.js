const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
const admin = require('firebase-admin');
// admin.initializeApp(functions.config().firebase)
admin.initializeApp();
// var db = admin.firestore();

// exports.userquestions = functions.firestore.document('users/{userId}/userquestions/{documentId}').onCreate((snap, context) => {
//   const newValue = snap.data();
//   const tablename = newValue.tablename;
//   const tags = newValue.tags;
//   const createdAt = newValue.createdAt
//   var data = {
//     tablename: tablename,
//     tags: tags,
//     createdAt: createdAt
//   }
//   db.doc('userquestions/{documentId}').set(data);

// });

exports.addMessage = functions.region('asia-northeast1').https.onRequest(async (req, res) => {
  // Grab the text parameter.
  const original = req.query.text;
  // Push the new message into the Realtime Database using the Firebase Admin SDK.
  const snapshot = await admin.database().ref('/messages').push({original: original});
  // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
  res.redirect(303, snapshot.ref.toString());
});

