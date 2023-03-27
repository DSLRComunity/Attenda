import 'package:firebase_auth/firebase_auth.dart';

class ClassModel {
  DateTime date;
  String time;
  int iteration;
  String region;
  String centerName;
  double classPrice;
  double maxQuizDegree;
  double maxHwDegree;
  double moneyCollected;
  int numOfAttendants;

  ClassModel({
    required this.date,
    required this.time,
    required this.region,
    required this.classPrice,
    required this.centerName,
    required this.iteration,
    required this.maxHwDegree,
    required this.maxQuizDegree,
    required this.moneyCollected,
    required this.numOfAttendants,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json, String date) {
    return ClassModel(
      date: DateTime.parse(date),
      time: json['time'],
      region: json['region'],
      classPrice: json['classPrice'],
      centerName: json['centerName'],
      iteration: json['iteration'],
      maxQuizDegree: json['maxQuizDegree'],
      maxHwDegree: json['maxHwDegree'],
      moneyCollected: json['moneyCollected'],
      numOfAttendants: json['numOfAttendants']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'region': region,
      'classPrice': classPrice,
      'centerName': centerName,
      'iteration': iteration,
      'uId':'zSEouWFmfMSvZsZcsgPO2qjdxeN2',                       //FirebaseAuth.instance.currentUser!.uid,
      'maxQuizDegree': maxQuizDegree,
      'maxHwDegree': maxHwDegree,
      'moneyCollected': moneyCollected,
      'numOfAttendants':numOfAttendants,
    };
  }
}
