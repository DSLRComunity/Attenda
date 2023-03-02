import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/colors.dart';
import '../../../home/models/dumy_model.dart';

class LinearChart extends StatelessWidget {
  const LinearChart({Key? key,required this.tooltipBehavior}) : super(key: key);

  final TooltipBehavior tooltipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.5,
      height: MediaQuery.of(context).size.height*.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          title: ChartTitle(text: 'Total Attendance Report',textStyle: Theme.of(context).textTheme.bodySmall),
          legend: Legend(isVisible: true),
          tooltipBehavior: tooltipBehavior,
          series: <LineSeries<SalesData, String>>[
            LineSeries<SalesData, String>(
              dataSource:  <SalesData>[
                SalesData('Jan', 35),
                SalesData('Feb', 28),
                SalesData('Mar', 34),
                SalesData('Apr', 32),
                SalesData('May', 40)
              ],
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales,
              color: MyColors.primary,
              markerSettings: const MarkerSettings(isVisible: true),
              // Enable data label
            )
          ]
      ),
    );
  }
}
