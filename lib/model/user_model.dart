import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String phoneNo;

  UserModel({
    this.id,
    required this.phoneNo,
  });

  toJson() {
    return {
      "Phone": phoneNo,
    };
  }

  /// Map user fetched from Firebase to UserModel
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      phoneNo: data["Phone"],
    );
  }
}
