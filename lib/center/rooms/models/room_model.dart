class RoomModel {
  String name;
  String id;

  RoomModel({required this.name,required this.id});

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(name: json['name'], id: json['id']);
  }
}

