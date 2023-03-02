import 'package:attenda/classes/business_logic/classes_cubit/classes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_button.dart';
import '../widgets/my_grid_view.dart';
import '../widgets/show_class_dialog.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({Key? key}) : super(key: key);

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {

  void _getClasses()async{
    await  ClassesCubit.get(context).getAllClasses();
    }

  @override
  void initState() {
    _getClasses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CustomButton(
                text: 'Add Class',
                onPressed: () {
                  showClassDialog(context);
                },
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            ClassesCubit.get(context).classes==[]? Center(child: Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('images/empty.gif')),
              ),
            )):
             const MyGridView(),
          ],
        ),
      ),
    );
  }
}
