const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase)

var db = admin.firestore();

exports.userquestions = functions.region('asia-northeast1').firestore.document('users/{userId}/userquestions/{documentId}').onCreate((snap, context) => {
  const newValue = snap.data();
  const tablename = newValue.tablename;
  const tags = newValue.tags;
  const createdAt = newValue.createdAt
  const documentId = snap.id;
  const userId = context.params.userId;
  var data = {
    tablename: tablename,
    tags: tags,
    createdAt: createdAt
  }
  data.userRef = db.collection('users').doc(userId);
  db.collection('userquestions').doc(documentId).set(data);

});
