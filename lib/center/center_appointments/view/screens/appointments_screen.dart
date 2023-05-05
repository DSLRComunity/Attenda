import 'package:attenda/center/new_booking/business_logic/booking_cubit.dart';
import 'package:attenda/center/center_home/business_logic/center_home_cubit/center_home_cubit.dart';
import 'package:attenda/center/center_appointments/models/event_model.dart';
import 'package:attenda/center/center_home/view/screens/s.dart';
import 'package:attenda/center/new_booking/view/screens/booking_dialog.dart';
import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:attenda/core/routing/routes.dart';
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
  late CalendarController _calendarController;
  DateTime initialDate = DateTime.now();

  @override
  void initState() {
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CenterHomeCubit, CenterHomeState>(
      listener: (context, state) {
        if (state is GetAppointmentsError) {
          showErrorToast(
              context: context,
              message: 'Some thing went error, please try again');
        }
      },
      child: BlocBuilder<CenterHomeCubit, CenterHomeState>(
          builder: (context, state) {
        var cubit = CenterHomeCubit.get(context);
        if (state is GetAppointmentsError) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetAppointmentsLoad) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: SfCalendar(
                  controller: _calendarController,
                  view: CalendarView.week,
                  firstDayOfWeek: 6,
                  showNavigationArrow: true,
                  showDatePickerButton: true,
                  initialDisplayDate: DateTime(initialDate.year,
                      initialDate.month, initialDate.day, 9, 0, 0),
                  dataSource: EventDataSource(CenterHomeCubit.get(context)
                      .makeAppointment(teacherView: false)),
                  onTap: (calendarTapDetails) {
                    if (calendarTapDetails.appointments != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const S()));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => BlocProvider(
                              create: (context) => BookingCubit(),
                              child: BookingDialog(
                                centerHomeCubit: cubit,
                              )));
                    }
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
                          onPressed: () async {},
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
        }
      }),
    );
  }
}
