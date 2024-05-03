import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class AuthRepo extends GetxController {
  static AuthRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
  }

  //Create a user
  createUser(UserModel user) async {
    final docUser = _db.collection("Student").doc();
    user = user.setId(docUser.id);
    await docUser.set(user.toJson());
  }

  //Get User
  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Student").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    return userData;
  }

//Sign Up
  Future<bool?> SignUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }
  //Sign In

  Future<bool?> SignIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      UserModel usr = await getUserDetails(email);
      if (usr.role == "Student")
        return true;
      else
        return false;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  

  //Add speciality to list
  Future<void> addSpecialiteToList(String userId, String element) async {
    try {
      final docRef = _db.collection("Student").doc(userId);
      await docRef.update({
        "listSpecialite": FieldValue.arrayUnion([element]),
      });
    } catch (e) {
      print("Erreur lors de l'ajout de l'élément à la liste : $e");
      throw e;
    }
  }

  // get list of speciality
  Stream<List<dynamic>> getListSpecility(String userId) {
    return _db.collection("Student").doc(userId).snapshots().map((docSnapshot) {
      if (docSnapshot.exists) {
        return List<dynamic>.from(docSnapshot.data()!["listSpecialite"]);
      } else {
        return [];
      }
    });
  }

   Future<void> deleteSpecialite(String userId, String speciality) async {
    try {
      final docRef = _db.collection("Student").doc(userId);
      await docRef.update({
        "listSpecialite": FieldValue.arrayRemove([speciality]),
      });
    } catch (e) {
      print("Error deleting speciality: $e");
      throw e;
    }
  }


    Future<void> logout() async {
    try {
      await _auth.signOut();
      print("logged out from Firebase");
    } catch (e) {
      print("Error logging out: $e");
      rethrow; 
    }
  }
}
