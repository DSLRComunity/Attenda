class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? uId;
  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.uId,
});

  Map<String,dynamic> toJson(){
    return {
      'firstName':firstName,
      'lastName':lastName,
      'email':email,
      'phone':phone,
      'uId':uId,
    };
  }

}