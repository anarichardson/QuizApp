import 'package:flutter/material.dart';
import 'post_data_function.dart';
import 'question_class.dart';

class QuizPage extends StatefulWidget {
  const QuizPage(
      {Key? key,
      required this.quizName,
      required this.userEmail,
      required this.refreshFunction})
      : super(key: key);
  final String quizName;
  final String userEmail;
  final Function refreshFunction;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Future<List>? futureQuestionList;
  List questions = [];

  Future<List>? appendElements(List elementsToAdd) async {
    final list = [];
    list.addAll(elementsToAdd);
    return list;
  }

  Map<int, dynamic> userAnswers = {};
  Map<int, dynamic> quizAnswers = {};

  void listBuilder() async {
    postData('getQuiz', {'quizName': widget.quizName}).then((value) {
      if (value.containsKey('questions')) {
        questions = value['questions'];
        List questionsList = [];
        for (Map<String, dynamic> question in questions) {
          questionsList.add(Question.fromJson(question));
        }
        futureQuestionList = appendElements(questionsList);
        setState(() {});
      }
    });
  }

  void addAnswers(int index, dynamic userAnswer, int quizAnswer) {
    setState(() {
      userAnswers[index] = userAnswer;
      quizAnswers[index] = quizAnswer;
    });
  }

  void submitQuiz(
      Map<int, dynamic> userAnswers, Map<int, dynamic> quizAnswers) {
    int score = 0;
    for (int i = 0; i < userAnswers.length; i++) {
      if (userAnswers[i] == quizAnswers[i]) {
        score = score + 1;
      }
    }
    showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                    "Your final score was $score out of ${questions.length}."),
                actions: [
                  TextButton(
                      onPressed: () {
                        postData('saveScore', {
                          'quizName': widget.quizName,
                          'score': '$score/${questions.length}',
                          'userEmail': widget.userEmail
                        }).then((value) => {Navigator.of(context).pop()});
                      },
                      child: const Text('Exit Quiz'))
                ],
              );
            })
        .then(
            (value) => {Navigator.of(context).pop(), widget.refreshFunction()});
  }

  @override
  void initState() {
    super.initState();
    listBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.quizName} Quiz'),
        ),
        body: FutureBuilder(
          future: futureQuestionList,
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData == true) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return QuestionWidget(
                        question: snapshot.data![index].question,
                        questionIndex: index,
                        options: snapshot.data![index].options,
                        answerFunction: addAnswers,
                        answer: snapshot.data![index].answer);
                  });
            } else if (snapshot.hasError) {
              throw Exception('${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        bottomNavigationBar: TextButton(
            onPressed: () {
              submitQuiz(userAnswers, quizAnswers);
            },
            child: const Text(
              'Submit Quiz',
              style: TextStyle(fontSize: 30),
            )));
  }
}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget(
      {Key? key,
      required this.question,
      required this.questionIndex,
      required this.options,
      required this.answerFunction,
      required this.answer})
      : super(key: key);
  final String question;
  final int questionIndex;
  final List<String?> options;
  final Function answerFunction;
  final int answer;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late String? selectedAnswer;

  @override
  void initState() {
    selectedAnswer = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            height: 225,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    minVerticalPadding: 2.5,
                    leading: Radio<String?>(
                      value: widget.options[index],
                      groupValue: selectedAnswer,
                      onChanged: (String? newAnswer) {
                        setState(() {
                          selectedAnswer = newAnswer;
                        });
                        widget.answerFunction(
                            widget.questionIndex, index, widget.answer);
                      },
                    ),
                    title: Text('${widget.options[index]}'),
                  );
                }),
          )
        ],
      ),
    );
  }
}
