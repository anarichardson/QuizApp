import 'package:flutter/material.dart';
import 'quiz_page.dart';

class QuizCard extends StatelessWidget {
  const QuizCard(
      {Key? key,
      required this.quizName,
      required this.quizScore,
      required this.userEmail,
      required this.refreshFunction})
      : super(key: key);
  final String quizName;
  final String quizScore;
  final String userEmail;
  final Function refreshFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(quizName),
          Text((quizScore == 'null')
              ? 'You have not taken this test yet.'
              : 'Your last score was $quizScore.'),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QuizPage(
                          quizName: quizName,
                          userEmail: userEmail,
                          refreshFunction: refreshFunction,
                        )));
              },
              child: const Text('Take Again?'))
        ],
      ),
    );
  }
}
