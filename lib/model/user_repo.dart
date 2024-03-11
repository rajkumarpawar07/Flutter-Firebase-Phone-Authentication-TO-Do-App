import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flyin/model/user_model.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  // instance of userRepository
  static UserRepository get instance => Get.find();

  // instance of firestore database
  final _db = FirebaseFirestore.instance;

  // create user
  createUser(UserModel user) async {
    await _db
        .collection("users") // name of your collection form firestore database
        .add(user
            .toJson()) // add mathod requires Map of strings and dynamic Map<string,Dynamic>
        .whenComplete(
          // when completed show snackbar
          () => Get.snackbar("Success", "You account has been created.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green),
        )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print("ERROR - $error");
    });
  }
}
