import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/colors.dart';
import '../widgets/circular_chart.dart';
import '../widgets/column_chart.dart';
import '../widgets/info_container.dart';
import '../widgets/linear_chart.dart';
import '../widgets/top_attendance.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late TooltipBehavior _tooltipBehavior;
@override
  void initState() {
  _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height*.35,
                color: Colors.transparent,
                child: Container(
                  height: MediaQuery.of(context).size.height*.25,
                  color: MyColors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    InfoContainer(title: 'TOTAL STUDENTS', icon: Icons.person_outline, num: 47,),
                    InfoContainer(title: 'PRESENT TODAY', icon: Icons.arrow_forward_outlined, num: 42,color: MyColors.primary,textColor: Colors.white),
                    InfoContainer(title: 'ABSENT TODAY', icon: Icons.close, num: 03),
                    InfoContainer(title: 'LATE TODAY', icon: Icons.access_alarms_sharp, num: 02),
                  ],),
              ),
            ],
          ),
          SizedBox(height:height*.05,),
          Padding(
            padding: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 10.h  ),
            child: Column(
              children: [
                Row(
                  children: [
                    LinearChart(tooltipBehavior: _tooltipBehavior),
                    SizedBox(width: 5.w,),
                    Expanded(child: ColumnChart(tooltipBehavior: _tooltipBehavior,))
                  ],
                ),
                SizedBox(height:height*.03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircularChart(tooltipBehavior: _tooltipBehavior),
                    SizedBox(width: 5.w,),
                    const TobAttendance(),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
