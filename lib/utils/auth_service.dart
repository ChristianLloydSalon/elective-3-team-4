import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:classenger_frontend/utils/user_credentials.dart';

class AuthService {
  AuthService({
    required this.email,
    required this.password,
    required this.role,
    this.userName,
  });

  final String email, password, role;
  String? userName;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // log in with email and password
  Future logInWithEmailAndPassword() async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      DocumentReference userDocRef = FirebaseFirestore.instance.collection("users").doc(user.uid);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      if (userDocSnapshot.exists) {
        Map<String, dynamic> userData = userDocSnapshot.data() as Map<String, dynamic>;
        userName = userData["user name"];
        saveUserID(user.uid);
      }
      return user;      
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future signUpWithEmailAndPassword() async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      await _db.collection("users").doc(user.uid).set({
        "email": email,
        "password": password,
        "role": role,
        "user name": userName,
      });
      saveUserID(user.uid);
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<bool> doesUserExist() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Future<bool> isPasswordValid() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('password', isEqualTo: password)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }
}