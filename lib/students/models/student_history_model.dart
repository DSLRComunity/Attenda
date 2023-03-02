class StudentHistory {
  String classDate;
  String className;
  String comment;
  String quizStatus;
  String quizDegree;
  String hwStatus;
  String hwDegree;
  double costPurchased;

  StudentHistory({required this.comment,
    required this.classDate,
    required this.className,
    required this.costPurchased,
    required this.hwDegree,
    required this.hwStatus,
    required this.quizDegree,
    required this.quizStatus});

  factory StudentHistory.fromJson(Map<String, dynamic>json){
    return StudentHistory(comment: json['comment'],
        classDate: json['classDate'],
        className: json['className'],
        costPurchased: json['cost'],
        hwDegree: json['hwDegree'],
        hwStatus: json['hwStatus'],
        quizDegree: json['quizDegree'],
        quizStatus: json['quizStatus']);
  }

  Map<String,dynamic>toJson(){
    return {
      'classDate':classDate,
      'className':className,
      'cost':costPurchased,
      'comment':comment,
      'hwStatus':hwStatus,
      'hwDegree':hwDegree,
      'quizStatue':quizStatus,
      'quizDegree':quizDegree,

    };
  }
}
