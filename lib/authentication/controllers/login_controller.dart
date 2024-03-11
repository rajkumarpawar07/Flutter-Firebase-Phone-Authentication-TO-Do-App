import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flyin/authentication/screens/otp/otp_screen.dart';

import 'package:flyin/model/user_model.dart';
import 'package:flyin/model/user_repo.dart';
import 'package:get/get.dart';

import '../authentication_repository.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final userRepo = Get.put(UserRepository());

  /// TextField Controllers to get data from TextFields
  final phoneNo = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  Rx<bool> isLoading = false.obs;

  login() {}

  Future<void> phoneAuthentication(String phoneNo) async {
    try {
      await AuthenticationRepository.instance.phoneAuthentication(phoneNo);
    } catch (e) {
      throw e.toString();
    }
  }

  // save phone number
  Future<void> createUser(UserModel user) async {
    isLoading.value = true;
    try {
      await userRepo.createUser(user);
      phoneAuthentication(user.phoneNo);
      isLoading.value = false;
      Get.to(() => const OTPScreen());
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5));
    }
  }

  // Future<void> storePhoneNumberInFirestore(String phoneNumber) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   String uid = FirebaseAuth.instance.currentUser!.uid;
  //
  //   await firestore.collection('users').doc(uid).set({
  //     'phoneNumber': phoneNumber,
  //   });
  //
  //   print('Phone number stored in Firestore: $phoneNumber');
  // }
}
