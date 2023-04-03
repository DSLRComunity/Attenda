import 'package:attenda/center/center_history/view/widgets/center_attendance_history.dart';
import 'package:attenda/center/center_history/view/widgets/center_manage_history.dart';
import 'package:attenda/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CenterHistoryScreen extends StatefulWidget {
  const CenterHistoryScreen({Key? key}) : super(key: key);

  @override
  State<CenterHistoryScreen> createState() => _CenterHistoryScreenState();
}

class _CenterHistoryScreenState extends State<CenterHistoryScreen>   with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: TabBar(
                      indicator: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      controller: _tabController,
                      labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
                      isScrollable: true,
                      tabs: [
                        Tab(
                          child: Text(
                            'Manage',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Attendance',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            Expanded(
                child: TabBarView(controller: _tabController,
                    children: const [
                     CenterManageHistory(),
                      CenterAttendanceHistory(),
                    ])),
          ],
        ),
      ),
    );
  }
}
