const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNewVideoNotification = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();

    const tokensSnapshot = await admin.firestore()
      .collection("deviceTokens")
      .get();

    const tokens = tokensSnapshot.docs.map(doc => doc.id);

    const payload = {
      notification: {
        title: "Новое видео!",
        body: data.title || "Добавлено новое видео",
      }
    };

    return admin.messaging().sendToDevice(tokens, payload);
  });
