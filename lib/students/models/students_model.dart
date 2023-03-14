class StudentsModel {
  String name;
  String phone;
  String parentPhone;
  String parentName;
  String id;
  String className;
  String gender;

  StudentsModel({
    required this.name,
    required this.phone,
    required this.parentName,
    required this.className,
    required this.parentPhone,
    required this.id,
    required this.gender,
  });

  factory StudentsModel.fromJson(Map<String, dynamic> json) {
    return StudentsModel(
      name: json['name'],
      phone: json['phone'],
      parentName: json['parentName'],
      parentPhone: json['parentPhone'],
      className: json['className'],
      id: json['id'],
      gender: json['gender'],
    );
  }

  Map<String,dynamic>toJson(){
    return {
      'name': name,
      'phone': phone,
      'parentName':parentName,
      'parentPhone': parentPhone,
      'className': className,
      'id': id,
      'gender':gender,
    };
  }

}
