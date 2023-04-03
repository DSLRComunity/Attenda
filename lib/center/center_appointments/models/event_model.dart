import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyEvent {
  String roomName;
  String teacherId;
  String teacherName;
  DateTime from;
  DateTime to;
  int recursion;
  int color;
  bool isAllDay;

  MyEvent({required this.roomName,
    required this.from,
    required this.to,
    required this.recursion,
    required this.color,
    required this.isAllDay,
    required this.teacherId,
    required this.teacherName});

  factory MyEvent.fromJson(Map<String, dynamic>json){
    return MyEvent(roomName: json['roomName'],
        from: DateTime.parse(json['from']),
        to: DateTime.parse(json['to']),
        recursion: json['recursion'],
        color: json['color'],
        isAllDay: json['isAllDay'],
        teacherId: json['teacherId'],
        teacherName: json['teacherName']);
  }

  Map<String,dynamic>toJson(){
    return {
      'roomName':roomName,
      'from':from.toString(),
      'to':to.toString(),
      'recursion':recursion,
      'color':color,
      'isAllDay':isAllDay,
      'teacherId':teacherId,
      'teacherName':teacherName,
    };
  }

}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment>source){
    appointments=source;
  }


}
