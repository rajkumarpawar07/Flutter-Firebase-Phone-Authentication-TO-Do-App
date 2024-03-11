import 'package:flyin/main.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../authentication_repository.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();
  Rx<bool> isLoadingOTP = false.obs;

  void verifyOTP(String otp) async {
    isLoadingOTP.value = true;
    try {
      var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
      isLoadingOTP.value = false;
      isVerified ? Get.offAll(ToDoListScreen()) : Get.back();
    } catch (e) {
      print('error $e');
      isLoadingOTP.value = false;
    }
  }
}
