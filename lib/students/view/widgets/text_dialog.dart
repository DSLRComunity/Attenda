import 'package:attenda/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Future<T?> showTextDialog<T>(
  BuildContext context, {
  required String title,
  required String value,

}) =>
    showDialog<T>(
      context: context,
      builder: (context) => TextDialogWidget(
        title: title,
        value: value,
      ),
    );

class TextDialogWidget extends StatefulWidget {
  final String title;
  final String value;

  const TextDialogWidget(
      {Key? key,
      required this.title,
      required this.value,

      required})
      : super(key: key);

  @override
  _TextDialogWidgetState createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: SizedBox(
          width: 60.w,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onFieldSubmitted: (val) async {
              Navigator.of(context).pop(controller.text);
            },
            maxLines: 4,
          ),
        ),
        actions: [
          ElevatedButton(
              child: const Text('Done'),
              onPressed: () async {
                Navigator.of(context).pop(controller.text);
              }),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(null),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: MyColors.grey),
            ),
          )
        ],
      );
}
