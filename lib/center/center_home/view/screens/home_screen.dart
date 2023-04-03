import 'package:attenda/center/center_appointments/view/screens/appointments_screen.dart';
import 'package:attenda/center/center_history/view/screens/center_history_screen.dart';
import 'package:attenda/center/center_home/business_logic/center_home_cubit/center_home_cubit.dart';
import 'package:attenda/center/center_requests/view/screens/center_requests_screen.dart';
import 'package:attenda/center/rooms/business_logic/rooms_cubit.dart';
import 'package:attenda/center/rooms/view/screens/rooms_screen.dart';
import 'package:attenda/core/cache_helper.dart';
import 'package:attenda/core/colors.dart';
import 'package:attenda/core/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CenterHomeScreen extends StatefulWidget {
  const CenterHomeScreen({Key? key}) : super(key: key);

  @override
  State<CenterHomeScreen> createState() => _CenterHomeScreenState();
}

class _CenterHomeScreenState extends State<CenterHomeScreen>with TickerProviderStateMixin {
  late TabController _tabController;

  void _getCenterData() async {
    await RoomsCubit.get(context).getRooms();
    await CenterHomeCubit.get(context).getAppointments();
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabColor);
    _getCenterData();
    super.initState();
  }
  void _handleTabColor() {
    setState(() {});
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
         // await CenterHomeCubit.get(context).close();
        }
      },
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: AppBar(
              elevation: 3,
              backgroundColor: MyColors.black,
              leadingWidth: MediaQuery.of(context).size.width * .38,
              leading: Row(
                children: [
                  Container(
                    height: 30.h,
                    width: 10.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.primary,
                    ),
                    child: Image.asset('${(kDebugMode && kIsWeb)?"":"assets/"}images/a.png'),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    'Attenda',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .25,
                      child: TabBar(
                        controller: _tabController,
                        indicator: UnderlineTabIndicator(
                            borderSide: const BorderSide(
                              width: 2,
                              color: MyColors.primary,
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.r),
                                topRight: Radius.circular(5.r))),
                        indicatorColor: MyColors.primary,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorPadding: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        dividerColor: Colors.white,
                        tabs: [
                          Text(
                            'Classes',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                color: _tabController.index == 0
                                    ? MyColors.primary
                                    : Colors.white,
                                fontSize: 16.sp),
                          ),
                          Text('Rooms',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                  color: _tabController.index == 1
                                      ? MyColors.primary
                                      : Colors.white,
                                  fontSize: 16.sp)),
                          Text('History',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                  color: _tabController.index == 2
                                      ? MyColors.primary
                                      : Colors.white,
                                  fontSize: 16.sp)),
                          Text('Requests',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                  color: _tabController.index == 3
                                      ? MyColors.primary
                                      : Colors.white,
                                  fontSize: 16.sp)),

                        ],
                      ),
                    ),
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
                    ))
              ],
            ),
          ),
          body: TabBarView(
              controller: _tabController,
              children: const [
            AppointmentsScreen(),
            RoomsScreen(),
            CenterHistoryScreen(),
            CenterRequestsScreen(),
          ]),

        ),
      ),
    );
  }

}
