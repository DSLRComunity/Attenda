class HistoryModel {
  String message;
  String userName;
  String date;

  HistoryModel(
      {required this.userName,
      required this.message,
      required this.date,
      });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
        userName: json['userName'],
        message: json['message'],
        date: json['date'],
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'message': message,
      'date': date,
    };
  }
}
