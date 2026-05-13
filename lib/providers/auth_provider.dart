import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // ── Getters ──────────────────────────────────────────────────────────────

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // ── Constructor ──────────────────────────────────────────────────────────

  AuthProvider() {
    _initializeUser();
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  // ── Private Methods ──────────────────────────────────────────────────────

  void _initializeUser() {
    _user = _firebaseAuth.currentUser;
    notifyListeners();
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // ── Public Methods ───────────────────────────────────────────────────────

  /// Login dengan email dan password
  Future<bool> loginWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      _setLoading(false);
      return false;
    }
  }

  /// Daftar dengan email dan password
  Future<bool> registerWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      _setLoading(false);
      return false;
    }
  }

  /// Login dengan Google
  Future<bool> loginWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      _setLoading(false);
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      _setLoading(true);
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      _setLoading(false);
    } catch (e) {
      _setError('Gagal logout: $e');
      _setLoading(false);
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);

      await _firebaseAuth.sendPasswordResetEmail(email: email);
      
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      _setLoading(false);
      return false;
    }
  }

  // ── Helper Methods ───────────────────────────────────────────────────────

  /// Konversi error code Firebase ke pesan yang user-friendly
  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar.';
      case 'user-not-found':
        return 'Email tidak ditemukan.';
      case 'wrong-password':
        return 'Password salah.';
      case 'invalid-email':
        return 'Email tidak valid.';
      case 'user-disabled':
        return 'Akun telah dinonaktifkan.';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan.';
      default:
        return 'Terjadi kesalahan: $code';
    }
  }
}
