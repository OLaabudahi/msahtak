import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Google Sign-In ط؛ظٹط± ظ…ط¯ط¹ظˆظ… ط¹ظ„ظ‰ ط§ظ„ظˆظٹط¨ ط¨ط¯ظˆظ† Client ID
  GoogleSignIn? get _googleSignIn => kIsWeb ? null : GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'fullName': fullName,
          'phoneNumber': '',
          'role': 'user',
          'status': 'active',
          'createdAt': FieldValue.serverTimestamp(),
        });

        return {'success': true, 'user': user};
      }

      return {'success': false, 'error': 'Failed to create user'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Sign in with email and password
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Get user role from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          String role = userData['role'] ?? 'user';
          final rawIds = userData['assignedSpaceIds'];
          final assignedSpaceIds = rawIds is List
              ? rawIds.map((e) => e.toString()).toList()
              : <String>[];

          return {'success': true, 'user': user, 'role': role, 'assignedSpaceIds': assignedSpaceIds};
        }

        return {'success': true, 'user': user, 'role': 'user', 'assignedSpaceIds': <String>[]};
      }

      return {'success': false, 'error': 'Failed to sign in'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Sign in with Google
  Future<Map<String, dynamic>> signInWithGoogle() async {
    if (kIsWeb) {
      return {'success': false, 'error': 'Google sign-in is not supported on web'};
    }
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();

      if (googleUser == null) {
        return {'success': false, 'error': 'Google sign in cancelled'};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        // Check if user exists in Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          // Create new user document
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'fullName': user.displayName ?? '',
            'phoneNumber': '',
            'role': 'user',
            'status': 'active',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        Map<String, dynamic> userData = userDoc.exists
            ? userDoc.data() as Map<String, dynamic>
            : {};
        String role = userData['role'] ?? 'user';

        return {'success': true, 'user': user, 'role': role};
      }

      return {'success': false, 'error': 'Failed to sign in with Google'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Get user role
  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['role'] ?? 'user';
      }

      return 'user';
    } catch (e) {
      return 'user';
    }
  }

  // Check if user is admin
  Future<bool> isAdmin(String uid) async {
    String role = await getUserRole(uid);
    return role == 'admin';
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn?.signOut();
    await _auth.signOut();
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {'success': true};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Error messages
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled. Please contact support';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      case 'requires-recent-login':
        return 'Please log in again to continue';
      default:
        return 'Error ($code). Please try again';
    }
  }
}


