class RoomModel {
  int maxSize;
  String feeMethod;
  int color;
  String roomNum;
  double price;

  RoomModel(
      {required this.maxSize,
      required this.feeMethod,
      required this.color,
      required this.roomNum,
      required this.price});

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
        maxSize: json['maxSize'],
        feeMethod: json['feeMethod'],
        color: json['color'],
        roomNum: json['roomNum'],
        price: json['price']);
  }

  Map<String, dynamic> toJson() {
    return {
      'roomNum': roomNum,
      'feeMethod': feeMethod,
      'maxSize': maxSize,
      'color': color,
      'price': price,
    };
  }
}
