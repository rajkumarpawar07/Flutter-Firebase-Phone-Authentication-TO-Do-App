import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyin/authentication/screens/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/otp_controller.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var otpController = Get.put(OTPController());
    var otp;
    return Scaffold(
      // floatingActionButton: Align(
      //   alignment: Alignment.bottomRight,
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: SizedBox(
      //       width: MediaQuery.of(context).size.width / 3,
      //       child: ElevatedButton(
      //         onPressed: () {
      //           // Navigator.push(
      //           //   context,
      //           //   MaterialPageRoute(builder: (context) => const LoginScreen()),
      //           // );
      //           Navigator.pop(context);
      //         },
      //         style: ElevatedButton.styleFrom(
      //           elevation: 10,
      //           foregroundColor: tWhiteColor,
      //           backgroundColor: tSecondaryColor,
      //           side: const BorderSide(color: tSecondaryColor),
      //           padding: const EdgeInsets.symmetric(vertical: 15),
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(30.0)),
      //         ),
      //         child: const Text("Back"),
      //       ),
      //     ),
      //   ),
      // ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "OTP CODE",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 80.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15.0),
              Text("Enter your OTP".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 10.0),
              const Text(
                  "Enter the verification code sent at your phone number.",
                  textAlign: TextAlign.center),
              const SizedBox(height: 20.0),
              OtpTextField(
                  mainAxisAlignment: MainAxisAlignment.center,
                  numberOfFields: 6,
                  fillColor: Colors.black.withOpacity(0.1),
                  filled: true,
                  onSubmit: (code) {
                    otp = code;
                    OTPController.instance.verifyOTP(otp);
                  }),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    OTPController.instance.verifyOTP(otp);
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
                  child: Obx(() => otpController.isLoadingOTP.value
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text("Get Started")),
                ),
              ),
              const SizedBox(height: 15),
              const Text("Didn't get the code? Resend")
            ],
          ),
        ),
      ),
    );
  }
}
