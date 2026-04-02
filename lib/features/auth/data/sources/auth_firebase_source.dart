import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../services/auth_service.dart';

class AuthFirebaseSource {
  final AuthService _service = AuthService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _service.signIn(email: email, password: password);
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _service.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<Map<String, dynamic>> resetPassword(String email) {
    return _service.resetPassword(email);
  }

  Future<void> signOut() {
    return _service.signOut();
  }
}
/*
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseSource {
  final FirebaseAuthService service;

  AuthFirebaseSource(this.service);

  Future<UserCredential> login(String email, String password) {
    return service.login(email, password);
  }

  Future<UserCredential> signup(String email, String password) {
    return service.signup(email, password);
  }

  Future<void> logout() {
    return service.logout();
  }

  User? getCurrentUser() {
    return service.getCurrentUser();
  }
}
*/


