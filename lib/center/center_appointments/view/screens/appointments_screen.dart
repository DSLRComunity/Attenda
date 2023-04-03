import 'package:attenda/center/center_home/business_logic/booking_cubit/booking_cubit.dart';
import 'package:attenda/center/center_home/business_logic/center_home_cubit/center_home_cubit.dart';
import 'package:attenda/center/center_appointments/models/event_model.dart';
import 'package:attenda/center/center_home/view/widgets/booking_dialog.dart';
import 'package:attenda/core/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  DateTime initialDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CenterHomeCubit, CenterHomeState>(
        buildWhen: (previous, current) =>
            current is GetAppointmentsLoad ||
            current is GetAppointmentsSuccess ||
            current is GetAppointmentsError,
        builder: (context, state) {
          var cubit = CenterHomeCubit.get(context);
          return Row(
            children: [
              Expanded(
                child: SfCalendar(
                  view: CalendarView.week,
                  firstDayOfWeek: 6,
                  showNavigationArrow: true,
                  showDatePickerButton: true,
                  initialDisplayDate: DateTime(initialDate.year,
                      initialDate.month, initialDate.day, 9, 0, 0),
                  dataSource: EventDataSource(CenterHomeCubit.get(context)
                      .makeAppointment(teacherView: false)),
                  onTap: (calendarTapDetails) {
                    showDialog(
                        context: context,
                        builder: (context) => BlocProvider(
                            create: (context) => BookingCubit(),
                            child: BookingDialog(
                              centerHomeCubit: cubit,
                            )));
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .06,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.centerProfile,
                                arguments: cubit);
                          },
                          icon: const Icon(Icons.person_outline)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.bathroom_outlined)),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
