import 'package:firebase_auth/firebase_auth.dart';
import 'package:flyin/authentication/screens/login/login_screen.dart';
import 'package:flyin/main.dart';
import 'package:get/get.dart';

class AuthenticationRepository extends GetxController {
  // instance for AuthenticationRepository
  static AuthenticationRepository get instance => Get.find();

  //Variables
  // instance for firebase
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> _firebaseUser;
  var verificationId = ''.obs;

  //Getters
  User? get firebaseUser => _firebaseUser.value;
  String get getUserID => firebaseUser?.uid ?? "";
  String get getUserEmail => firebaseUser?.email ?? "";

  //Will be load when app launches this func will be called and set the firebaseUser state
  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    // on going to execute when app launch first time
    setInitialScreen(_firebaseUser.value);
    // ever(_firebaseUser, _setInitialScreen);
  }

  /// If we are setting initial screen from here
  /// then in the main.dart => App() add CircularProgressIndicator()
  setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const LoginScreen())
        : Get.offAll(() => ToDoListScreen());
    // : Get.offAll(() => const MailVerification());
  }

  // phone authentication
  Future<void> loginWithPhoneNo(String phoneNo) async {
    try {
      await _auth.signInWithPhoneNumber(phoneNo);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-phone-number') {
        Get.snackbar("Error", "Invalid Phone No");
      }
    } catch (_) {
      Get.snackbar("Error", "Something went wrong");
    }
  }

  // phone authentication
  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
        },
        codeSent: (verificationId, resendToken) {
          this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            Get.snackbar('Error', 'The provided phone number is not valid');
          } else {
            Get.snackbar("Error", "Something went wrong try again");
          }
        });
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: this.verificationId.value, smsCode: otp));

    return credentials.user != null ? true : false;
  }

  // Future<void> createUserWithPhoneNo(
  //     String PhoneNo) async {
  //   try {
  //     await _auth.signInWithPhoneNumber(phoneNumber)
  //     _firebaseUser.value != null
  //         ? Get.offAll(() => const ProfileScreen())
  //         : Get.to(() => const splashScreen());
  //   } on FirebaseAuthException catch (e) {
  //     final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
  //     throw ex.message;
  //   } catch (_) {
  //     const ex = SignUpWithEmailAndPasswordFailure();
  //     throw ex.message;
  //   }
  // }
}
