class Question {
  int? answer;
  List<String>? options;
  String? question;

  Question({this.answer, this.options, this.question});

  Question.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    options = json['options'].cast<String>();
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['answer'] = answer;
    data['options'] = options;
    data['question'] = question;
    return data;
  }
}