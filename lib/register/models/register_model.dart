class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? uId;
  String? technicalSupportNum;
  String? expectedStudentsNum;
  String? governorate;
  String? governorateCode;
  String? subject;
  bool isComplete;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.uId,
    required this.governorate,
    required this.expectedStudentsNum,
    required this.technicalSupportNum,
    required this.governorateCode,
    required this.subject,
    required this.isComplete,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'uId': uId,
      'governorate': governorate,
      'expectedStudentsNum': expectedStudentsNum,
      'technicalSupportNum': technicalSupportNum,
      'governorateCode': governorateCode,
      'subject': subject,
      'isComplete': isComplete,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic>json){
    return UserModel(firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        phone: json['phone'],
        uId: json['uId'],
        governorate: json['governorate'],
        expectedStudentsNum: json['expectedStudentsNum'],
        technicalSupportNum: json['technicalSupportNum'],
        governorateCode: json['governorateCode'],
        subject: json['subject'],
        isComplete:json['isComplete'],
    );
  }

}