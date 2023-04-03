import 'package:attenda/center/center_home/business_logic/center_home_cubit/center_home_cubit.dart';
import 'package:attenda/center/rooms/business_logic/rooms_cubit.dart';
import 'package:attenda/class_details/business_logic/class_details_cubit.dart';
import 'package:attenda/classes/business_logic/classes_cubit/classes_cubit.dart';
import 'package:attenda/core/routes.dart';
import 'package:attenda/core/strings.dart';
import 'package:attenda/home/business_logic/home_cubit.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: Constants.apiKey,
      appId: Constants.appId,
      authDomain: "attenda-ac62f.firebaseapp.com",
      messagingSenderId: Constants.messagingSenderId,
      projectId: Constants.projectId,
      storageBucket: "attenda-ac62f.appspot.com",
      databaseURL: "https://attenda-ac62f-default-rtdb.firebaseio.com",
      measurementId: "G-G7B7W8VTET",
    ));
  } else {
    await Firebase.initializeApp();
  }
  await CacheHelper.init();
  String initialRoute;
  uId = CacheHelper.getData(key: 'uId');
  role=CacheHelper.getData(key: 'role');
  if (uId != null) {
    if(role=='t'){
      initialRoute=Routes.homeRoute;
    }else{
      initialRoute = Routes.centerHomeRoute;
    }
    if (kDebugMode) {
      print('$uId');
    }
  } else {
    initialRoute = Routes.welcomeRoute;
  }
  // DioHelper.init();
  runApp(MyApp(initialRoute: initialRoute,));
  Bloc.observer = MyBlocObserver();
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

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
              BlocProvider(create: (_)=>HomeCubit()),
              BlocProvider(create: (_)=>RoomsCubit()),

            ],
            child: MaterialApp(
              title: 'Attenda',
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              onGenerateRoute: AppRouter(initialRoute).generateRoute,
            ),
          );
        });
  }
}

//flutter build web --web-renderer canvaskit