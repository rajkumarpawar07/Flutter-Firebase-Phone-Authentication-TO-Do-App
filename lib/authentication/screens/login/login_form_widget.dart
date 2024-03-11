import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flyin/model/user_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/login_controller.dart';
import '../otp/otp_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final controller = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    Country countrySelected = Country(
        phoneCode: "91",
        countryCode: "IN",
        e164Sc: 0,
        geographic: true,
        level: 1,
        name: "India",
        example: "India",
        displayName: "India",
        displayNameNoCountryCode: "IN",
        e164Key: "");
    return Form(
      key: controller.loginFormKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controller.phoneNo,
              // onChanged: (value) {
              //   _formKey.currentState?.validate();
              // },
              keyboardType: TextInputType.number,
              maxLength: 10,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please Enter a Phone Number";
                } else if (!RegExp(
                        r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
                    .hasMatch(value)) {
                  return "Please Enter a Valid Phone Number";
                }
                if (controller.phoneNo.text.length != 10) {
                  return "Please Enter a Valid Phone Number";
                }
              },
              decoration: InputDecoration(
                  label: const Text(
                    "Enter Phone Number",
                    style: TextStyle(color: Colors.black38),
                  ),
                  hintText: "Enter Phone Number",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black)),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 550),
                            onSelect: (value) {
                              setState(() {
                                countrySelected = value;
                              });
                            });
                      },
                      child: Text(
                        "${countrySelected.flagEmoji} +${countrySelected.phoneCode}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ),
                  )),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    final user = UserModel(
                        phoneNo: "+91${controller.phoneNo.text.trim()}");
                    if (controller.loginFormKey.currentState != null &&
                        controller.loginFormKey.currentState!.validate()) {
                      // LoginController.instance.phoneAuthentication(
                      //     "+91${controller.phoneNo.text.trim()}");
                      LoginController.instance.createUser(user);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                  child: Obx(() => controller.isLoading.value
                      ? const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                      : Text("Get OTP")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// String? validateMobile(String value) {
//   String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
//   RegExp regExp = new RegExp(patttern);
//   if (value.length == 0) {
//     return 'Please enter mobile number';
//   } else if (!regExp.hasMatch(value)) {
//     return 'Please enter valid mobile number';
//   }
//   return null;
// }
