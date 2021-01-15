import 'package:firebase_auth/firebase_auth.dart';
import 'package:voting_system/services/db.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges();
  }

  String getCurrentUserID() {
    return _firebaseAuth.currentUser.uid;
  }

  bool checkEmailVerification() {
    return _firebaseAuth.currentUser.emailVerified;
  }

  Future registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      await user.sendEmailVerification();
      await DatabaseService().createUserData(user.uid, username, email);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
