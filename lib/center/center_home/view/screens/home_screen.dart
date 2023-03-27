import 'package:attenda/center/center_home/business_logic/center_home_cubit.dart';
import 'package:attenda/center/center_home/models/event_model.dart';
import 'package:attenda/center/center_home/view/widgets/booking_dialog.dart';
import 'package:attenda/center/new_room/business_logic/add_room_cubit.dart';
import 'package:attenda/center/new_room/view/room_dialog.dart';
import 'package:attenda/core/cache_helper.dart';
import 'package:attenda/core/colors.dart';
import 'package:attenda/core/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CenterHomeScreen extends StatefulWidget {
  const CenterHomeScreen({Key? key}) : super(key: key);

  @override
  State<CenterHomeScreen> createState() => _CenterHomeScreenState();
}

class _CenterHomeScreenState extends State<CenterHomeScreen> {
  void _getCenterData() async {
    await CenterHomeCubit.get(context).getRooms();
    await CenterHomeCubit.get(context).getAppointments();
    await CenterHomeCubit.get(context).getCenterData();
  }

  DateTime initialDate = DateTime.now();

  @override
  void initState() {
    _getCenterData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CenterHomeCubit, CenterHomeState>(
      listener: (context, state) async {
        if (state is LogoutSuccess) {
          if (await CacheHelper.removeValue(key: 'uId') &&
              await CacheHelper.removeValue(key: 'role')) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.welcomeRoute, (route) => false);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          backgroundColor: MyColors.black,
          leadingWidth: MediaQuery.of(context).size.width * .48,
          leading: Row(
            children: [
              Container(
                height: 30.h,
                width: 10.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.primary,
                ),
                child: Image.asset(
                    '${(kDebugMode && kIsWeb) ? "" : "assets/"}images/a.png'),
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                'Attenda',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  await CenterHomeCubit.get(context).logout();
                },
                child: Text(
                  'Logout',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: MyColors.primary),
                )),
          ],
        ),
        body: BlocBuilder<CenterHomeCubit, CenterHomeState>(
          builder: (context, state) => Row(
            children: [
              Expanded(
                child: SfCalendar(
                  view: CalendarView.week,
                  firstDayOfWeek: 6,
                  showNavigationArrow: true,
                  showDatePickerButton: true,
                  initialDisplayDate: DateTime(initialDate.year,initialDate.month,initialDate.day,9,0,0 ),
                  dataSource: EventDataSource(CenterHomeCubit.get(context).makeAppointment(teacherView: false)),
                  onTap: (calendarTapDetails) {
                    showDialog(
                        context: context,
                        builder: (context) => const BookingDialog());
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .06,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: Column(
                    children: [
                      IconButton(onPressed: (){
                        Navigator.pushNamed(context, Routes.centerProfile);
                      }, icon: const Icon(Icons.person_outline)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.bathroom_outlined)),
                      SizedBox(
                        height: 10.h,
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => BlocProvider(
                                    create: (context) => AddRoomCubit(),
                                    child: const RoomDialog()));
                          },
                          icon: const Icon(Icons.add)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
