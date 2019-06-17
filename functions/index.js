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
  const createdAt = newValue.createdAt;
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

exports.createdetails = functions.region('asia-northeast1').firestore.document('users/{userId}/userquestions/{documentId}/details/{detailId}').onCreate((snap, context) => {
  const newValue = snap.data();
  const detail = newValue.detail;
  const createdAt = newValue.createdAt;
  const detailId = snap.id;
  const documentId = context.params.documentId;
  var data = {
    detail: detail,
    createdAt: createdAt
  }
  db.collection('userquestions').doc(documentId).collection('details').doc(detailId).set(data);

});

exports.deletequestion = functions.region('asia-northeast1').firestore.document('users/{userId}/userquestions/{documentId}').onDelete((snap, context) => {
  const documentId = context.params.documentId;
  db.collection('userquestions').doc(documentId).delete();
});

exports.updatefirst = functions.region('asia-northeast1').firestore.document('users/{userId}/userquestions/{documentId}').onUpdate((change, context) => {
  const newValue = change.after.data();
  const tablename = newValue.tablename;
  const tags = newValue.tags;
  const createdAt = newValue.createdAt;
  const documentId = context.params.documentId;
  var data = {
    tablename: tablename,
    tags: tags,
    createdAt: createdAt
  }
  db.collection('userquestions').doc(documentId).update(data);
});

exports.updatedetails = functions.region('asia-northeast1').firestore.document('users/{userId}/userquestions/{documentId}/details/{detailId}').onUpdate((change, context) => {
  const newValue = change.after.data();
  const detail = newValue.detail;
  const detailId = context.params.detailId;
  const documentId = context.params.documentId;
  db.collection('userquestions').doc(documentId).collection('details').doc(detailId).update({detail: detail});
});
