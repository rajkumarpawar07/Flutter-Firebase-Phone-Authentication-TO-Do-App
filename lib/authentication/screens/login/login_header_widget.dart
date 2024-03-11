import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
              'https://media.istockphoto.com/id/1351624100/vector/sign-in-page-abstract-concept-vector-illustration.jpg?s=612x612&w=0&k=20&c=ZT5PwIi-fgRZe6yXQ0DhYMi9bDWK_ey1hk0skDKmnaM=',
              height: size.height * 0.4),
          const Text("Register",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Add your phone number to register. We'll send you a verification code.",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black38),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
