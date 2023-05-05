class UserModel {
  String? name;
  String? email;
  String? phone;
  String? technicalSupportNum;
  String? expectedStudentsNum;
  String? governorate;
  String address;
  String? subject;
  String? password;
  String? confirmPassword;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.governorate,
      required this.address,
      required this.expectedStudentsNum,
      required this.technicalSupportNum,
      required this.subject,
      required this.password,
      required this.confirmPassword});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'teche_phone': phone,
      'city': governorate,
      'maxStudent': expectedStudentsNum,
      'work_phone': technicalSupportNum,
      'speciality': subject,
      'address': address,
      'password': password,
      'password_confirmation': confirmPassword,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      phone: json['teche_phone'],
      governorate: json['city'],
      expectedStudentsNum: json['maxStudent'],
      technicalSupportNum: json['work_phone'],
      subject: json['speciality'],
      address: json['address'],
      password: json['password'],
      confirmPassword: json['password_confirmation'],
    );
  }
}
