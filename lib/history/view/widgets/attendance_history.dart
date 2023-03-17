import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/colors.dart';
import '../../business_logic/history_cubit.dart';
import 'history_item.dart';

class AttendanceHistory extends StatefulWidget {
  const AttendanceHistory({Key? key}) : super(key: key);

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  _getInit() async {
    if(HistoryCubit.get(context).attendanceHistory.isEmpty){
      await HistoryCubit.get(context).getAttendanceHistory();
    }
  }

  @override
  void initState() {
    _getInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryCubit, HistoryState>(
        buildWhen: (previous, current) => (current is GetAttendanceHistoryLoad ||
            current is GetAttendanceHistorySuccess ||
            current is GetAttendanceHistoryError),
        listenWhen:(previous, current) => current is GetAttendanceHistoryError,
        builder: (context, state) {
            if(state is GetAttendanceHistoryLoad){
              return const Center(child: CircularProgressIndicator(),);
            }else{
              return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return HistoryItem(
                      message:
                      HistoryCubit.get(context).attendanceHistory[index].message,
                      date: HistoryCubit.get(context).attendanceHistory[index].date,
                    );
                  },
                  separatorBuilder: (context, index) =>
                  const Divider(color: MyColors.grey),
                  itemCount: HistoryCubit.get(context).attendanceHistory.length);
            }
        },
        listener: (context, state) {
          if(state is GetAttendanceHistoryError){
            showErrorToast(context: context, message: 'Error try again');
          }
        },
    );

  }
}
