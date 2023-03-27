import 'package:attenda/classes/models/class_model.dart';
import 'package:attenda/classes/view/widgets/custom_button.dart';
import 'package:attenda/classes/view/widgets/get_day_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/colors.dart';
import '../../../core/routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: MyColors.black,
        leadingWidth: MediaQuery.of(context).size.width * .48,
        leading: Row(
          children: [
            Container(
              height: 30.h,
              width: 10.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.primary,
              ),
              child: Image.asset(
                  '${(kDebugMode && kIsWeb) ? "" : "assets/"}images/a.png'),
            ),
            SizedBox(
              width: 2.w,
            ),
            Text(
              'Attenda',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.chooseRoleRoute);
              },
              child: const Text(
                'Login',
                style: TextStyle(color: MyColors.white),
              ))
        ],
      ),
    );
  }

  // List<ClassModel> classes = [];
  // Future<void> edit() async {
  //   print('start');
  //   classes=[];
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc('zSEouWFmfMSvZsZcsgPO2qjdxeN2')
  //       .collection('classes')
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) {
  //       classes.add(ClassModel.fromJson(element.data(), DateTime.now().toString()));
  //     });
  //     print(classes);
  //     classes.forEach((currentClass) async {
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc('zSEouWFmfMSvZsZcsgPO2qjdxeN2')
  //           .collection('classes')
  //           .doc(getClassName(currentClass))
  //           .collection('dates')
  //           .get()
  //           .then((value)async {
  //             print(value.docs);
  //         value.docs.forEach((element) async {
  //           await FirebaseFirestore.instance
  //               .collection('users')
  //               .doc('zSEouWFmfMSvZsZcsgPO2qjdxeN2')
  //               .collection('classes')
  //               .doc(getClassName(currentClass))
  //               .collection('dates')
  //               .doc(element.id)
  //               .set(currentClass.toJson());
  //         });
  //       });
  //     });
  //   });
  // }
  //
  // Future<void>fun()async{
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc('zSEouWFmfMSvZsZcsgPO2qjdxeN2')
  //         .collection('classes').doc('Wednesday, 6:00 PM').get().then((currentClass) async {
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc('zSEouWFmfMSvZsZcsgPO2qjdxeN2')
  //           .collection('classes').doc('Wednesday, 6:00 PM').collection('dates').get().then((value)async{
  //             value.docs.forEach((element) async{
  //               await FirebaseFirestore.instance
  //                   .collection('users')
  //                   .doc('zSEouWFmfMSvZsZcsgPO2qjdxeN2')
  //                   .collection('classes').doc('Wednesday, 6:00 PM').collection('dates').doc(element.id).set(currentClass.data()!);
  //             });
  //       });
  //     });
  // }
  //
  // Future<void>editStudent()async{
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc('zSEouWFmfMSvZsZcsgPO2qjdxeN2') .collection('students').where('className',isEqualTo: 'Monday, 2:30 PM').get().then((value){
  //         value.docs.forEach((element) async{
  //           await FirebaseFirestore.instance
  //               .collection('users')
  //               .doc('zSEouWFmfMSvZsZcsgPO2qjdxeN2') .collection('students').doc(element.id).collection('history').get().then((value)async{
  //
  //           });
  //         });
  //   });
  // }
}
