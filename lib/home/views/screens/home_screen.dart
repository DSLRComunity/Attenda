import 'package:attenda/classes/business_logic/classes_cubit/classes_cubit.dart';
import 'package:attenda/classes/view/screens/classes_screen.dart';
import 'package:attenda/core/cache_helper.dart';
import 'package:attenda/core/colors.dart';
import 'package:attenda/core/routes.dart';
import 'package:attenda/dash_board/views/screens/dashboard_screen.dart';
import 'package:attenda/history/view/screens/historyScreen.dart';
import 'package:attenda/home/business_logic/home_cubit.dart';
import 'package:attenda/home/views/widgets/search_field.dart';
import 'package:attenda/students/business_logic/students_cubit/students_cubit.dart';
import 'package:attenda/students/view/screens/students_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../history/business_logic/history_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  void _getInitialData() async {
    await ClassesCubit.get(context).getAllClasses();
    await StudentsCubit.get(context).getAllStudents();
    await HomeCubit.get(context).getUserData();
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabColor);
    _getInitialData();
    super.initState();
  }

  void _handleTabColor() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) async {
        if (state is LogoutSuccess) {
          if (await CacheHelper.removeValue(key: 'uId')) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.homeLoginRoute, (route) => false);
          }
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .38,
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
                            'OverView',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: _tabController.index == 0
                                        ? MyColors.primary
                                        : Colors.white,
                                    fontSize: 16.sp),
                          ),
                          Text('Manage classes',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: _tabController.index == 1
                                          ? MyColors.primary
                                          : Colors.white,
                                      fontSize: 16.sp)),
                          Text('Manage students',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: _tabController.index == 2
                                          ? MyColors.primary
                                          : Colors.white,
                                      fontSize: 16.sp)),
                          Text('History',
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
                const SearchField(),
                TextButton(
                    onPressed: () async {
                      await HomeCubit.get(context).logout();
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
            children:  [
              const DashBoard(),
              const ClassesScreen(),
              const StudentsScreen(),
              BlocProvider(create: (context) => HistoryCubit(),child: const HistoryScreen()),
            ],
          ),
        ),
      ),
    );
  }
}
