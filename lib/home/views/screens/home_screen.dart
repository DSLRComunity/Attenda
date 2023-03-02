import 'package:attenda/classes/view/screens/classes_screen.dart';
import 'package:attenda/core/colors.dart';
import 'package:attenda/dash_board/views/screens/dashboard_screen.dart';
import 'package:attenda/home/views/widgets/search_field.dart';
import 'package:attenda/students/view/screens/students_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>with TickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
_tabController=TabController(vsync: this, length: 3);
_tabController.addListener(_handleTabColor);

    super.initState();
  }

  void _handleTabColor(){
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: AppBar(
            elevation: 3,
            backgroundColor: MyColors.black,
            leadingWidth: MediaQuery.of(context).size.width*.44,
            leading: Row(
              children: [
                Container(
                  height: 20.h,
                  width: 10.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColors.primary,
                  ),
                ),
                SizedBox(width: 3.w,),
                Text('Attenda',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white,fontWeight: FontWeight.bold),),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*.35,
                    child: TabBar(
                      controller: _tabController,
                      indicator:  UnderlineTabIndicator(
                        borderSide: const BorderSide(
                          width: 2,
                          color: MyColors.primary,
                        ),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5.r),topRight: Radius.circular(5.r))
                      ),
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
                              .copyWith(color: _tabController.index==0 ?MyColors.primary:Colors.white, fontSize: 16.sp),
                        ),
                        Text('Manage classes',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: _tabController.index==1 ?MyColors.primary:Colors.white, fontSize: 16.sp)),
                        Text('Manage students',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: _tabController.index==2 ?MyColors.primary:Colors.white, fontSize: 16.sp)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: const [
              SearchField(),
            ],
          ),
        ),
        body:TabBarView(
          controller: _tabController,
          children:  const [
            DashBoard(),
            ClassesScreen(),
            StudentsScreen(),
          ],

        ) ,
      ),
    );
  }
}
