import 'package:flutter/material.dart';
import 'package:tester/form_text_field.dart';
import 'package:tester/sign_up_page.dart';
import 'post_data_function.dart';
import 'home_page.dart';
import 'storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Map quizScores = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: ListView(
        children: [
          FormTextField(label: "Email", textController: emailController),
          FormTextField(label: "Password", textController: passwordController),
          TextButton(
              onPressed: () {
                postData('/login', {
                  'email': emailController.text,
                  'password': passwordController.text
                }).then((value) async => {
                      if (value['success'] == true)
                        {
                          await storage.write(key: 'token', value: '${value['token']}'),
                          quizScores = value['quizScores'],
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
                              }).then((value) => {
                                Navigator.of(context).pop(),
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomePage(
                                        userEmail: emailController.text,
                                        quizScores: quizScores)))
                              })
                        }
                      else if (value['success'] == false)
                        {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(value['message']),
                                );
                              })
                        }
                    });
              },
              child: const Text('Login')),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignUpPage()));
              },
              child: const Text('Sign Up'))
        ],
      ),
    );
  }
}
