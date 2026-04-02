import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../features/auth/data/models/auth_user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GoogleSignIn? get _googleSignIn => kIsWeb ? null : GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

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

          return {
            'success': true,
            'user': user,
            'role': role,
            'assignedSpaceIds': assignedSpaceIds,
          };
        }

        return {
          'success': true,
          'user': user,
          'role': 'user',
          'assignedSpaceIds': <String>[],
        };
      }

      return {'success': false, 'error': 'Failed to sign in'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _getErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }


  Future<AuthUserModel> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();

    if (googleUser == null) {
      throw Exception('Google sign in cancelled');
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    final user = result.user;

    if (user == null) {
      throw Exception('User is null');
    }

    final docRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await docRef.get();

    if (!userDoc.exists) {
      await docRef.set({
        'uid': user.uid,
        'email': user.email ?? '',
        'fullName': user.displayName ?? '',
        'phoneNumber': '',
        'role': 'user',
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    final data = (await docRef.get()).data()!;

    // 🔥 رجّعي Model مش Map
    return AuthUserModel(
      id: data['uid'],
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      role: data['role'] ?? 'user', assignedSpaceIds: [],
    );
  }
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

  Future<bool> isAdmin(String uid) async {
    String role = await getUserRole(uid);
    return role == 'admin';
  }

  Future<void> signOut() async {

    await _googleSignIn?.signOut();
    await _auth.signOut();
  }

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
