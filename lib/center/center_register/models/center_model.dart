class CenterRegisterModel {
  String email;
  String password;
  String passwordConfirmation;
  String city;
  String address;
  String phone;
  String centerName;

  CenterRegisterModel({
    required this.email,
    required this.phone,
    required this.centerName,
   required this.password,
    required this.passwordConfirmation,
    required this.address,
    required this.city
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'name': centerName,
      'password':password,
      'password_confirmation':passwordConfirmation,
      'city':city,
      'address':address,
    };
  }
}
