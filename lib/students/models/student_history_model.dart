class StudentHistory {
  String name;
  String id;
  String classDate;
  String className;
  String comment;
  String quizStatus;
  String quizDegree;
  bool hwStatus;
  String hwDegree;
  double costPurchased;

  StudentHistory(
      {required this.name,
      required this.id,
      required this.comment,
      required this.classDate,
      required this.className,
      required this.costPurchased,
      required this.hwDegree,
      required this.hwStatus,
      required this.quizDegree,
      required this.quizStatus});

  factory StudentHistory.fromJson(Map<String, dynamic> json) {
    return StudentHistory(
        name: json['name'].toString(),
        id: json['id'].toString(),
        comment: json['comment'].toString(),
        classDate: json['classDate'].toString(),
        className: json['className'].toString(),
        costPurchased: json['cost'],
        hwDegree: json['hwDegree'].toString(),
        hwStatus: json['hwStatus'],
        quizDegree: json['quizDegree'].toString(),
        quizStatus: json['quizStatus'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'classDate': classDate,
      'className': className,
      'cost': costPurchased,
      'comment': comment,
      'hwStatus': hwStatus,
      'hwDegree': hwDegree,
      'quizStatue': quizStatus,
      'quizDegree': quizDegree,
    };
  }
}
