import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService{
  //instance of auth & firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  Future<void> updateUserFCMToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      final token = await FirebaseMessaging.instance.getToken();
      await _firestore.collection('User').doc(user.uid).update({
        'fcmToken': token,
      });
    }
  }

  //sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async{
    try {
      //sign user in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password);
      //save user info if it doesn't already exist
      _firestore.collection("User").doc(userCredential.user!.uid).set(
        {
          'uid' : userCredential.user!.uid,
          'email': email,
        },
      );

      await updateUserFCMToken();

      return userCredential;
    } on FirebaseException catch (e){
      throw Exception(e.code);
    }
  }
  //sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password)async{
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password);
      //save user info in a separate doc
      _firestore.collection("User").doc(userCredential.user!.uid).set(
        {
          'uid' : userCredential.user!.uid,
          'email': email,
        },
      );

      await updateUserFCMToken();

      return userCredential;
    } on FirebaseException catch (e){
      throw Exception(e.code);
    }
  }
  //sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
//errors
}