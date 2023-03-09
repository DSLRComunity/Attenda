import 'package:attenda/classes/models/class_model.dart';
import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../students/models/student_history_model.dart';
import '../../../students/view/widgets/scrollable_widget.dart';
import '../../business_logic/class_details_cubit.dart';

class HistoryDetails extends StatefulWidget {
  const HistoryDetails({Key? key, required this.currentClass})
      : super(key: key);
  final ClassModel currentClass;

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
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

  List<dynamic> quizStatuses = [
    'لم يؤدي',
    'أدى في بداية الحصة',
    'أدى في نهاية الحصة',
  ];

  List<dynamic> hwStatuses = [
    false,
    true,
  ];

  List<String> columnsLabels = [
    'whatsapp',
    'name',
    'quiz status',
    'quiz degree',
    'HW status',
    'HW degree',
    'comment',
    'Pay',
  ];

  List<DataColumn> getColumns(List<String> columnsLabels) {
    return columnsLabels
        .map((label) => DataColumn(label: Text(label)))
        .toList();
  }

  List<DataRow> getRows(List<StudentHistory> histories) {
    List<DataRow> historyList = [];
    histories.forEach((history) {
      historyList.add(DataRow(cells: [
        DataCell(SizedBox(
            width: 20.w,
            child: WhatsappButton(parentNum: history.parentPhone, message: makeTemplate(history)))),
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
              await ClassDetailsCubit.get(context).updateQuizStatus(
                  history.id, newValue.toString(), widget.currentClass);
              setState(() {});
            },
            items: <DropdownMenuItem<dynamic>>[
              const DropdownMenuItem(
                value: 'لم يؤدي',
                child: Text('لم يؤدي'),
              ),
              DropdownMenuItem(
                  value: quizStatuses[1], child: const Text('أدى في بداية الحصة')),
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
                await ClassDetailsCubit.get(context)
                    .updateQuizDegree(history.id, val, widget.currentClass);
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
            TextFormField(
              initialValue: history.comment,
              keyboardType: TextInputType.text,
              onFieldSubmitted: (val) async {
                history.comment = val;
                await ClassDetailsCubit.get(context)
                    .updateComment(history.id, val, widget.currentClass);
              },
            ),
            showEditIcon: true),
        DataCell(
            TextFormField(
              initialValue: history.costPurchased.toString(),
              keyboardType: TextInputType.name,
              onFieldSubmitted: (val) async {
                history.costPurchased = double.parse(val);
                await ClassDetailsCubit.get(context).updateCost(
                    history.id, double.parse(val), widget.currentClass);
              },
            ),
            showEditIcon: true),
      ]));
    });
    return historyList;
  }
  String makeTemplate(StudentHistory history) {
    String hwStatus=history.hwStatus?'سلم الواجب':'لم يسلم الواجب ';
    String template = ' ${history.comment}. و خاصه بتعليق المدرس الخاص ${history.costPurchased} و قام بدفع ${history.hwDegree} بدرجة $hwStatus و بخصوص الواجب ف قد ${history.quizDegree} بدرجة ${history.quizStatus}و قد ${history.classDate} قد حضر ابنكم/ابنتكم حصة يوم ${history.name}الي ولي امر الطالب ';
    return template;
  }

}

class WhatsappButton extends StatelessWidget {
  const WhatsappButton({
    Key? key,
    required this.parentNum,
    required this.message,
  }) : super(key: key);
  final String parentNum;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
        ),
        onPressed: () async {
          await openWhatsapp(parentNum, message);
        },
        child: SvgPicture.asset(
          'assets/images/whatsapp.svg',
          fit: BoxFit.cover,
          width: 30.w,
          height: 30.h,
        ));
  }

  Future<void> openWhatsapp(String num, String message) async {
    var whatsappUrl =
        'https://api.whatsapp.com/send/?phone=+2$num&text=$message';
    launchUrl(Uri.parse(whatsappUrl));
  }

}
