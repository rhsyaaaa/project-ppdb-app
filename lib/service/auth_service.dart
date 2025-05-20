// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ppdb_app/core/routing/app_route.dart';

class AuthService {
  void login(String emailAddress, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      // Jika login berhasil
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login successful!')));

      // Navigasi ke halaman HomePage
      context.go('/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found for that email.')),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong password provided for that user.')),
        );
      }
    }
  }

  void register(
    String emailAddress,
    String password,
    String displayName,
    BuildContext context,
  ) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );

      await credential.user?.updateDisplayName(displayName);

      await credential.user?.reload();

      final user = FirebaseAuth.instance.currentUser;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration successful! Welcome ${user?.displayName ?? 'user'}',
          ),
        ),
      );

      context.go('/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The password provided is too weak.')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The account already exists for that email.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  void forgotPassword(BuildContext context) {
    context.goNamed(Routes.forgotPassword);
  }

  void send_email(String email) async {
    try {
      print('Mengirim email reset password ke: $email');
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Email reset password berhasil dikirim.');
    } catch (e) {
      print('Error saat mengirim email: $e');
    }
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Logout successful!')));
  }

  Future sign_with_google(BuildContext context) async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider.addScope(
        'https://www.googleapis.com/auth/contacts.readonly',
      );
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      await FirebaseAuth.instance.signInWithPopup(googleProvider);
      context.goNamed(Routes.home);
    } else {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      context.goNamed(Routes.home);
    }
  }
}
