import 'package:flutter/material.dart';
import 'main.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SignInPage()));
        },
        icon: const Icon(Icons.logout, color: Colors.white,));
  }
}
