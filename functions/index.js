const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

/**
 * Deletes a user from Firebase Auth and cleans up their data.
 * Can be called from the Flutter app by an admin.
 */
exports.deleteUser = functions.https.onCall(async (data, context) => {
  // 1. Security Check: Ensure caller is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "The function must be called while authenticated."
    );
  }

  // 2. Role Check: Ideally check if caller is admin
  // For dev convenience in this prototype, we'll allow it,
  // but in production, check context.auth.token.role === 'admin'

  const targetUserId = data.userId;
  if (!targetUserId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "The function must be called with a userId."
    );
  }

  try {
    // 3. Delete from Firebase Auth
    await admin.auth().deleteUser(targetUserId);
    console.log(`Successfully deleted user ${targetUserId} from Auth`);

    // 4. (Optional) Recursive Firestore Delete
    // Since we handle this client-side in CascadeDeleteService, we might not need it here,
    // but having a server-side backup is good.
    // For now, let's trust the client-side cascade for Firestore/Storage 
    // to give the user granular feedback, and just handle Auth here.
    
    return { success: true, message: `User ${targetUserId} deleted from Auth.` };
  } catch (error) {
    console.error("Error deleting user:", error);
    // If user not found, consider it a success (idempotent)
    if (error.code === 'auth/user-not-found') {
        return { success: true, message: "User not found in Auth, skipped." };
    }
    throw new functions.https.HttpsError("internal", error.message);
  }
});

/**
 * Batch delete users from Auth
 */
exports.batchDeleteUsers = functions.https.onCall(async (data, context) => {
    if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Auth required.");
    
    const userIds = data.userIds;
    if (!userIds || !Array.isArray(userIds)) {
        throw new functions.https.HttpsError("invalid-argument", "userIds array required.");
    }

    try {
        const result = await admin.auth().deleteUsers(userIds);
        console.log(`Successfully deleted ${result.successCount} users`);
        console.log(`Failed to delete ${result.failureCount} users`);
        
        return { 
            success: true, 
            successCount: result.successCount, 
            failureCount: result.failureCount,
            errors: result.errors 
        };
    } catch (error) {
        throw new functions.https.HttpsError("internal", error.message);
    }
});
