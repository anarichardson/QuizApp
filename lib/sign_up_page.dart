import 'package:flutter/material.dart';
import 'post_data_function.dart';
import 'form_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController fnController = TextEditingController();
  TextEditingController lnController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up'),),
      body: ListView(
        children: [
          FormTextField(label: "First Name", textController: fnController),
          FormTextField(label: "Last Name", textController: lnController),
          FormTextField(label: "Email", textController: emailController),
          FormTextField(label: "Password", textController: passwordController),
          TextButton(onPressed: () {
            postData('/register', {'email': emailController.text,
              'firstName': fnController.text,
              'lastName': lnController.text,
              'password': passwordController.text
            }).then((value) =>
            {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(value['message']),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Ok'))
                      ],
                    );
                  }).then((value) =>
              {
                Navigator.of(context).pop(),
            })
          });
            },
              child: const Text('Submit')),
        ],
      ),
    );
  }
}
