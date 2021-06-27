const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.onCreateFollowPosts = functions.firestore.document("/userFollows/{userId}/followPosts/{postId}").onCreate(async (snapshot, context) => {
    console.log("UserFollowPosts: ", snapshot.data());
    const postId = context.params.postId;
    const userId = context.params.userId;
    //create postsRef
    const followPostsRef = admin.firestore().collection("posts").document(postId);
    //create userFollowPostsRef
    const userFollowPostsRef = admin.firestore().collection("userFollowPosts").document(userId).collection("posts");
    // get post
    const querySnapshot = await followPostsRef.get();
    // add post in followPost
    querySnapshot.foreach(doc => {
        if(doc.exists) {
            const postId = doc.id;
            const postData = doc.data();
            userFollowPostsRef.document(postId).set(postData);
        }
    });
});
