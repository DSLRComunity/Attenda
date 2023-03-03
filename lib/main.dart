import 'package:attenda/class_details/business_logic/class_details_cubit.dart';
import 'package:attenda/classes/business_logic/classes_cubit/classes_cubit.dart';
import 'package:attenda/core/routes.dart';
import 'package:attenda/core/strings.dart';
import 'package:attenda/students/business_logic/students_cubit/students_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc_observer.dart';
import 'core/cache_helper.dart';
import 'core/firebase_config/firebase_config.dart';
import 'core/router.dart';
import 'core/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  }else{
    await Firebase.initializeApp();
  }
  await CacheHelper.init();
  String initialRoute;
  uId = CacheHelper.getData(key: 'uId');
  if (uId != null) {
    initialRoute = Routes.homeRoute;
    if (kDebugMode) {
      print('$uId');
    }
  } else {
    initialRoute =Routes.homeLoginRoute;
  }
  runApp( MyApp(initialRoute: initialRoute,));
  Bloc.observer = MyBlocObserver();
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key,required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ClassesCubit()),
              BlocProvider(create: (_) => StudentsCubit()),
              BlocProvider(create: (_) => ClassDetailsCubit()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              onGenerateRoute: AppRouter().generateRoute,
              initialRoute: initialRoute,
            ),
          );
        });
  }
}

