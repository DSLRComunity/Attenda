import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyBooking {
  String id;
  String date;
  String time;
  String duration;
  int color;

  MyBooking({
    required this.id,
    required this.color,
    required this.time,
    required this.duration,
    required this.date,
  });

  factory MyBooking.fromJson(Map<String, dynamic> json) {
    return MyBooking(
      color: Colors.teal.value,
      id: json['id'],
      date: json['from'],
      time: json['start'],
      duration: json['do'],
    );
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
