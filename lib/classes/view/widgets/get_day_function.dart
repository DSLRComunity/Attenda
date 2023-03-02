import 'package:intl/intl.dart';

import '../../models/class_model.dart';

String getDayFrom(DateTime date)=>DateFormat('EEEE').format(date);
String getClassName(ClassModel currentClass) {
  return '${getDayFrom(currentClass.date)}, ${currentClass.time}';
}