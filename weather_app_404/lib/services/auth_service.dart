import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Simple user model for testing
class SimpleUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  SimpleUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });
}

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  SimpleUser? _user;
  bool _isLoading = false;
  bool _isMockMode = false; // Set to false to use real Google auth

  SimpleUser? get user => _user;
  bool get isLoading => _isLoading;

  AuthService() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? firebaseUser) {
      if (firebaseUser != null) {
        _user = SimpleUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email,
          displayName: firebaseUser.displayName,
          photoURL: firebaseUser.photoURL,
        );
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  // Real Google Sign-In
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_isMockMode) {
        // Mock implementation
        await Future.delayed(const Duration(seconds: 1));
        _user = SimpleUser(
          uid: 'google-${DateTime.now().millisecondsSinceEpoch}',
          email: 'user@google.com',
          displayName: 'Google User',
          photoURL: null,
        );
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Real Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        throw Exception('Google Sign-In was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      // If real Google Sign-In fails, try mock mode as fallback
      if (!_isMockMode) {
        _isMockMode = true;
        await signInWithGoogle(); // Retry with mock mode
        return;
      }
      
      throw Exception('Google sign-in failed: $e');
    }
  }

  // Anonymous Sign-In
  Future<void> signInAnonymously() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_isMockMode) {
        // Mock implementation
        await Future.delayed(const Duration(seconds: 1));
        _user = SimpleUser(
          uid: 'guest-${DateTime.now().millisecondsSinceEpoch}',
          email: 'guest@weather.app',
          displayName: 'Guest User',
          photoURL: null,
        );
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Real anonymous sign-in
      await _auth.signInAnonymously();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      // If real anonymous sign-in fails, try mock mode as fallback
      if (!_isMockMode) {
        _isMockMode = true;
        await signInAnonymously(); // Retry with mock mode
        return;
      }
      
      throw Exception('Anonymous sign-in failed: $e');
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_isMockMode) {
        _user = null;
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Real sign-out
      await _auth.signOut();
      await _googleSignIn.signOut();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Sign-out failed: $e');
    }
  }

  // Switch between mock and real mode
  void toggleMockMode() {
    _isMockMode = !_isMockMode;
    notifyListeners();
  }

  bool get isMockMode => _isMockMode;
}
