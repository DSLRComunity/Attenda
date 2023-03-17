import 'package:attenda/classes/models/class_model.dart';
import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:attenda/core/colors.dart';
import 'package:attenda/students/models/students_model.dart';
import 'package:attenda/students/view/widgets/text_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../students/models/student_history_model.dart';
import '../../../students/view/widgets/scrollable_widget.dart';
import '../../../whatsapp/business_logic/functions.dart';
import '../../../whatsapp/view/widgets/whatsapp_button.dart';
import '../../business_logic/class_details_cubit.dart';
import 'data.dart';

class HistoryDetails extends StatefulWidget {
  const HistoryDetails({Key? key, required this.currentClass})
      : super(key: key);
  final ClassModel currentClass;

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  StudentsModel? student;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClassDetailsCubit, ClassDetailsState>(
      listenWhen: (previous, current) => (current is! UpdateDetailsLoad ||
          current is! UpdateDetailsError ||
          current is! UpdateHistorySuccess),
      listener: (context, state) {
        if (state is UpdateDetailsError) {
          showErrorToast(context: context, message: 'Error: Try again');
        }
      },
      child: BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
        buildWhen: (previous, current) => (current is! UpdateDetailsLoad ||
            current is! UpdateDetailsError ||
            current is! UpdateHistorySuccess),
        builder: (context, state) {
          if (state is GetClassHistoryLoad) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ScrollableWidget(
              child: Column(
                children: [
                  DataTable(
                    columns: getColumns(columnsLabels),
                    rows: getRows(ClassDetailsCubit.get(context)
                        .classHistory), //getRows(ClassDetailsCubit.get(context).classStudents!),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columnsLabels) {
    return columnsLabels
        .map((label) => DataColumn(label: Text(label)))
        .toList();
  }

  List<DataRow> getRows(List<StudentHistory> histories) {
    List<DataRow> historyList = [];
    histories.forEach((history) {
      historyList.add(DataRow(cells: [
        DataCell(
           SizedBox(
            width: 15.w, child: WhatsappButton(
                num:history.parentPhone,
                message: makeTemplate(history,context,history.name)))),
        DataCell(
          TextFormField(
            enabled: false,
            initialValue: history.name,
          ),
        ),
        DataCell(
          DropdownButton<dynamic>(
            value: history.quizStatus,
            onChanged: (Object? newValue) async {
              history.quizStatus = newValue;
              await ClassDetailsCubit.get(context).updateQuizStatus(history.id, newValue.toString(), widget.currentClass);
              setState(() {});
            },
            items: <DropdownMenuItem<dynamic>>[
              const DropdownMenuItem(
                value: 'لم يؤدي',
                child: Text('لم يؤدي'),
              ),
              DropdownMenuItem(
                  value: quizStatuses[1],
                  child: const Text('أدى في بداية الحصة')),
              DropdownMenuItem(
                value: quizStatuses[2],
                child: const Text('أدى في نهاية الحصة'),
              ),
            ],
          ),
        ),
        DataCell(
            TextFormField(
              initialValue: history.quizDegree,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (val) async {
                history.quizDegree = val;
                await ClassDetailsCubit.get(context).updateQuizDegree(history.id, val, widget.currentClass);
              },
            ),
            showEditIcon: true),
        DataCell(
          DropdownButton<dynamic>(
            value: history.hwStatus,
            onChanged: (Object? newValue) async {
              history.hwStatus = newValue;
              await ClassDetailsCubit.get(context)
                  .updateHwStatus(history.id, newValue, widget.currentClass);
              setState(() {});
            },
            items: <DropdownMenuItem<dynamic>>[
              DropdownMenuItem(
                value: hwStatuses[0],
                child: const Text(
                  'No',
                ),
              ),
              DropdownMenuItem(
                value: hwStatuses[1],
                child: const Text('Yes'),
              ),
            ],
          ),
        ),
        DataCell(
            TextFormField(
              initialValue: history.hwDegree,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (val) async {
                history.hwDegree = val;
                await ClassDetailsCubit.get(context)
                    .updateHwDegree(history.id, val, widget.currentClass);
              },
            ),
            showEditIcon: true),
        DataCell(
          SizedBox(width: 30.w,child: Text(history.comment,maxLines: 1,overflow: TextOverflow.ellipsis)),
          onTap: () async {
            String? comment = await showTextDialog(context,
                title: 'Add comment',
                value: history.comment,);
            if(comment!=null){
              history.comment=comment;
              await ClassDetailsCubit.get(context)
                  .updateComment(history.id, comment, widget.currentClass);
            }
          },
          showEditIcon: true,
        ),
        DataCell(
            TextFormField(
              initialValue: history.costPurchased.toString(),
              keyboardType: TextInputType.name,
              onFieldSubmitted: (val) async {
                double difference=history.costPurchased-double.parse(val);

                history.costPurchased = double.parse(val);
                await ClassDetailsCubit.get(context).updateCost(history.id, double.parse(val), widget.currentClass);
                ClassDetailsCubit.get(context).totalMoney+=difference;
               await ClassDetailsCubit.get(context).updateMoneyCollected(widget.currentClass);
              },
            ),
            showEditIcon: true),
        DataCell(IconButton(
          onPressed: () async {
            // ClassDetailsCubit.get(context).classAttendants--;
            // ClassDetailsCubit.get(context).totalMoney-=history.costPurchased;
            // await ClassDetailsCubit.get(context).updateMoneyCollected(widget.currentClass);
            // await ClassDetailsCubit.get(context).updateNumOfAttendants(widget.currentClass);
            await ClassDetailsCubit.get(context).removeFromAttendance(history.id, widget.currentClass,context);
          },
          icon: const Icon(
            Icons.group_remove_outlined,
            color: MyColors.primary,
          ),
        )),
      ]));
    });
    return historyList;
  }

}

