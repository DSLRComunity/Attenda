class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? uId;
  String? technicalSupportNum;
  String? expectedStudentsNum;
  String? governorate;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.uId,
    required this.governorate,
    required this.expectedStudentsNum,
    required this.technicalSupportNum,
  });

  Map<String,dynamic> toJson(){
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'uId': uId,
      'governorate': governorate,
      'expectedStudentsNum': expectedStudentsNum,
      'technicalSupportNum': technicalSupportNum,
    };
  }

}