class StudentHistory {
  String name;
  String id;
  String classDate;
  String className;
  String comment;
  var quizStatus;
  String quizDegree;
  dynamic hwStatus;
  String hwDegree;
  double costPurchased;
  String parentPhone;
  String parentName;

  StudentHistory({
    required this.name,
    required this.id,
    required this.comment,
    required this.classDate,
    required this.className,
    required this.costPurchased,
    required this.hwDegree,
    required this.hwStatus,
    required this.quizDegree,
    required this.quizStatus,
    required this.parentPhone,
    required this.parentName,
  });

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
      quizStatus: json['quizStatus'],
      parentPhone: json['parentPhone'],
      parentName: json['parentName'],
    );
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
      'quizStatus': quizStatus.toString(),
      'quizDegree': quizDegree,
      'parentPhone': parentPhone,
      'parentName': parentName,
    };
  }
}
