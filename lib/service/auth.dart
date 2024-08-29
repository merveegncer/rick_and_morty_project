import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/service/firestore_service.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  String? get userID => currentUser?.uid;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Register

  Future<void> createUser(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({"email": email, "name": name});
    } on FirebaseAuthException catch (e) {
      print('Hata Oluştu: ${e.message}');
      throw e; // Hata mesajını yukarıya ilet
    }

    // await addFavorite(userCredential.user!.uid, 'episodeID456', 'Favori Bölüm Adı');
  }

  // login

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {}
    } on FirebaseAuthException catch (e) {
      print('Hata Oluştu: ${e.message}');
      throw e; // Hata mesajını yukarıya ilet
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String? getUserEmail() {
    return _firebaseAuth.currentUser?.email;
  }
}
