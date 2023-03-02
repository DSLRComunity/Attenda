import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../home/models/dumy_model.dart';

class CircularChart extends StatelessWidget {
  const CircularChart({Key? key,required this.tooltipBehavior}) : super(key: key);
  final TooltipBehavior tooltipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.25,
      height: MediaQuery.of(context).size.height*.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      child: SfCircularChart(

          title: ChartTitle(text: 'Total Attendance Report',textStyle: Theme.of(context).textTheme.bodySmall),
          legend: Legend(isVisible: true),
          tooltipBehavior: tooltipBehavior,
          series: <CircularSeries>[
            PieSeries<Gender,String>(
              dataSource:  <Gender>[
                Gender('Male', 25),
                Gender('Female', 75),
              ],
              xValueMapper: (Gender gender, _) => gender.gender,
              yValueMapper: (Gender gender, _) => gender.count,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              // Enable data label
            )
          ]
      ),
    );
  }
}
