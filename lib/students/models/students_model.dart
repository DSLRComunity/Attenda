class StudentsModel {
  String name;
  String phone;
  String parentPhone;
  String id;
  String className;
  String nationalId;

  // Map<String,StudentHistory>? studentHistory={'0':StudentHistory(comment: '', classDate: '', costPurchased: 0.0, degree: '', hwDegree: '', hwStatus: false, quizDegree: '', quizStatus: false)};

  StudentsModel({
    required this.name,
    required this.phone,
    required this.className,
    required this.parentPhone,
    required this.id,
    required this.nationalId,
    // required this.studentHistory
  });

  factory StudentsModel.fromJson(Map<String, dynamic> json) {
    return StudentsModel(
      phone: json['phone'],
      className: json['className'],
      name: json['name'],
      parentPhone: json['parentPhone'],
      id: json['id'],
      nationalId: json['nationalId'],
    );
  }

  Map<String,dynamic>toJson(){
    return {
      'name': name,
      'phone': phone,
      'parentPhone': parentPhone,
      'className': className,
      'id': id,
      'nationalId': nationalId,
    };
  }

}
