import 'package:flutter/material.dart';
import 'log_out_button.dart';
import 'post_data_function.dart';
import 'quiz_card.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.userEmail, required this.quizScores})
      : super(key: key);
  final String userEmail;
  Map quizScores;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void refresh() {
    postData('/getQuizScores', {'email': widget.userEmail}).then((value) => {
          setState(() {
            widget.quizScores = value['quizScores'];
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: const [LogOutButton()],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            refresh();
          },
          child: ListView(
            children: [
              QuizCard(
                quizName: 'Algebra',
                quizScore: widget.quizScores['Algebra'],
                userEmail: widget.userEmail,
                refreshFunction: refresh,
              ),
              QuizCard(
                quizName: 'Science',
                quizScore: widget.quizScores['Science'].toString(),
                userEmail: widget.userEmail,
                refreshFunction: refresh,
              ),
              QuizCard(
                quizName: 'Biology',
                quizScore: widget.quizScores['Biology'].toString(),
                userEmail: widget.userEmail,
                refreshFunction: refresh,
              ),
              QuizCard(
                quizName: 'Chemistry',
                quizScore: widget.quizScores['Chemistry'].toString(),
                userEmail: widget.userEmail,
                refreshFunction: refresh,
              ),
              QuizCard(
                quizName: 'Geography',
                quizScore: widget.quizScores['Geography'].toString(),
                userEmail: widget.userEmail,
                refreshFunction: refresh,
              )
            ],
          ),
        ));
  }
}
