const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendFCMMessage = functions.https.onCall(async (data, context) => {
  const { token, title, body } = data;

 // Checking if the user is authenticated
 if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
  }

  const message = {
    notification: {
      title: title,
      body: body
    },
    token: token
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    return { success: true, response: response };
  } catch (error) {
    console.log('Error sending message:', error);
    throw new functions.https.HttpsError('internal', error.message);
  }
});