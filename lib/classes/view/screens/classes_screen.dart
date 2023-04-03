import 'package:attenda/classes/business_logic/classes_cubit/classes_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
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
  final _scrollController=ScrollController();

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
      child: ImprovedScrolling(
        scrollController:_scrollController ,
        enableKeyboardScrolling: true,
        keyboardScrollConfig: KeyboardScrollConfig(
          arrowsScrollAmount: 100,
          homeScrollDurationBuilder: (currentScrollOffset, minScrollOffset) {
            return const Duration(milliseconds: 100);
          },
          endScrollDurationBuilder: (currentScrollOffset, maxScrollOffset) {
            return const Duration(milliseconds: 2000);
          },
        ),
        child: SingleChildScrollView(
          controller:_scrollController ,
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
                decoration:  const BoxDecoration(
                  image: DecorationImage(image: AssetImage('${(kDebugMode && kIsWeb)?"":"assets/"}images/empty.gif')),
                ),
              )):
               const MyGridView(),
            ],
          ),
        ),
      ),
    );
  }
}
