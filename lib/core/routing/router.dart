import 'package:attenda/center/center_home/business_logic/center_home_cubit/center_home_cubit.dart';
import 'package:attenda/center/center_home/view/screens/home_screen.dart';
import 'package:attenda/center/center_login/business_logic/center_home_login/center_login_cubit.dart';
import 'package:attenda/center/center_login/business_logic/center_login_cubit/center_login_cubit.dart';
import 'package:attenda/center/center_login/view/screens/center_home_login.dart';
import 'package:attenda/center/center_profile/business_logic/profile_cubit.dart';
import 'package:attenda/center/center_profile/view/screens/profile_screen.dart';
import 'package:attenda/center/center_register/bsuiness_logic/center_register_cubit.dart';
import 'package:attenda/center/center_requests/buiness_logic/request_details_cubit/request_details_cubit.dart';
import 'package:attenda/center/center_requests/view/screens/center_request_details.dart';
import 'package:attenda/center/new_teacher/business_logic/new_teacher_cubit.dart';
import 'package:attenda/center/new_teacher/view/screens/new_teacher_screen.dart';
import 'package:attenda/center/room_details/business_logic/room_details_cubit.dart';
import 'package:attenda/center/room_details/view/room_details_screen.dart';
import 'package:attenda/center/rooms/models/room_model.dart';
import 'package:attenda/class_details/view/screens/class_details_screen.dart';
import 'package:attenda/classes/models/class_model.dart';
import 'package:attenda/core/routing/animations.dart';
import 'package:attenda/core/routing/routes.dart';
import 'package:attenda/home/views/screens/home_screen.dart';
import 'package:attenda/login/business_logic/home_login_cubit/home_login_cubit.dart';
import 'package:attenda/login/business_logic/login_cubit/login_cubit.dart';
import 'package:attenda/login/views/screens/choose_screen.dart';
import 'package:attenda/login/views/screens/home_login.dart';
import 'package:attenda/register/business_logic/register_cubit.dart';
import 'package:attenda/splash/splash_screen.dart';
import 'package:attenda/students/business_logic/add_student_cubit/add_student_cubit.dart';
import 'package:attenda/students/models/students_model.dart';
import 'package:attenda/students/view/screens/edit_student_screen.dart';
import 'package:attenda/students/view/screens/new_student_screen.dart';
import 'package:attenda/welcome/view/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  String firstRoute;

  AppRouter(this.firstRoute);

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(
            builder: (_) => SplashScreen(
                  nextRoute: firstRoute,
                ));
      case Routes.welcomeRoute:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case Routes.chooseRoleRoute:
        return MaterialPageRoute(builder: (_) => const ChooseScreen());
      case Routes.homeLoginRoute:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider(create: (_) => HomeLoginCubit()),
                  BlocProvider(create: (_) => RegisterCubit()),
                  BlocProvider(create: (_) => LoginCubit()),
                ], child: const HomeLogin()));
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.newStudentRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (_) => AddStudentCubit(),
                child: const NewStudentScreen()));
      case Routes.editStudentRoute:
        final student = settings.arguments as StudentsModel;
        return MaterialPageRoute(
            builder: (_) => EditStudentScreen(student: student));
      case Routes.classDetailsRoute:
        final currentClass = settings.arguments as ClassModel;
        return MaterialPageRoute(
            builder: (_) => ClassDetailsScreen(currentClass: currentClass));
      case Routes.centerLoginRoute:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => CenterHomeLoginCubit(),
                    ),
                    BlocProvider(create: (context) => CenterRegisterCubit()),
                    BlocProvider(create: (context) => CenterLoginCubit()),
                  ],
                  child: const CenterHomeLogin(),
                ));
      case Routes.centerHomeRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => CenterHomeCubit(),
                child: const CenterHomeScreen()));
      case Routes.registerTeacher:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => NewTeacherCubit(),
                child: const NewTeacherScreen()));
      case Routes.centerProfile:
        final cubit = settings.arguments as CenterHomeCubit;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => ProfileCubit(),
                child: CenterProfileScreen(
                  centerHomeCubit: cubit,
                )));
      case Routes.roomDetails:
        final roomModel = settings.arguments as RoomModel;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => RoomDetailsCubit(),
                  child: RoomDetailsScreen(model: roomModel),
                ));
      case Routes.centerRequestDetails:
        final param = settings.arguments as Map<String, dynamic>;

        return CustomPageRoute(child: BlocProvider(
          create: (context) => RequestDetailsCubit(),
          child: CenterRequestDetails(
              centerRequest: param['centerRequest'],
              requestsPagingController: param['requestsPagingController']),
        ));
    }
    return null;
  }
}
