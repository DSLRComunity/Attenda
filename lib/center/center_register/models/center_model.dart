class CenterModel {
  String email;
  String attendaEmail;
  String centerName;
  int roomsNum;
  String phone;
  String location;
  String feeMethod;
  String info;

  CenterModel({
    required this.email,
    required this.phone,
    required this.centerName,
    required this.attendaEmail,
    required this.location,
    required this.roomsNum,
    required this.feeMethod,
    required this.info,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      email: json['email'],
      phone: json['phone'],
      centerName: json['centerName'],
      attendaEmail: json['attendaEmail'],
      location: json['location'],
      roomsNum: json['roomsNum'],
      feeMethod: json['feeMethod'],
      info:json['info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'centerName': centerName,
      'attendaEmail': attendaEmail,
      'location': location,
      'roomsNum': roomsNum,
      'feeMethod': feeMethod,
      'info':info,
    };
  }
}
