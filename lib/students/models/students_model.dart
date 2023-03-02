class StudentsModel {
  String name;
  String phone;
  String parentPhone;
  String id;
  String className;
  // Map<String,StudentHistory>? studentHistory={'0':StudentHistory(comment: '', classDate: '', costPurchased: 0.0, degree: '', hwDegree: '', hwStatus: false, quizDegree: '', quizStatus: false)};

  StudentsModel({
    required this.name,
    required this.phone,
    required this.className,
    required this.parentPhone,
    required this.id,
    // required this.studentHistory
  });

  factory StudentsModel.fromJson(Map<String, dynamic> json) {
    return StudentsModel(
        phone: json['phone'],
        className: json['className'],
        name: json['name'],
        parentPhone: json['parentPhone'],
        id: json['id']);
  }

  Map<String,dynamic>toJson(){
    return {
      'name':name,
      'phone':phone,
      'parentPhone':parentPhone,
      'className':className,
      'id':id,
    };
  }

// StudentsModel edit({
//   bool? quizStatus,
//   String? quizDegree,
//   String? hwDegree,
//   bool? hwStatus,
//   String? comment,
//   double? pay,
//   required DateTime date,
//
// }) {
//   studentHistory![date.toString()] = StudentHistory(
//       comment: comment ?? studentHistory![date.toString()]!.comment,
//       classDate: date.toString(),
//       costPurchased: pay?? studentHistory![date.toString()]!.costPurchased,
//       degree: '',
//       hwDegree: hwDegree?? studentHistory![date.toString()]!.hwDegree,
//       hwStatus: hwStatus?? studentHistory![date.toString()]!.hwStatus,
//       quizDegree: quizDegree?? studentHistory![date.toString()]!.quizDegree,
//       quizStatus: quizStatus?? studentHistory![date.toString()]!.quizStatus);
//   return StudentsModel(
//     phone: phone,
//     classTime: classTime,
//     firstName: firstName,
//     lastName: lastName,
//     parentPhone: parentPhone,
//     id: id,
//     studentHistory: studentHistory,
//   );
// }
}
