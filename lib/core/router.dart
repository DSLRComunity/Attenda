import 'package:attenda/class_details/view/screens/class_details_screen.dart';
import 'package:attenda/classes/models/class_model.dart';
import 'package:attenda/core/routes.dart';
import 'package:attenda/home/business_logic/home_cubit.dart';
import 'package:attenda/home/views/screens/home_screen.dart';
import 'package:attenda/login/business_logic/home_login_cubit/home_login_cubit.dart';
import 'package:attenda/login/business_logic/login_cubit/login_cubit.dart';
import 'package:attenda/login/views/screens/home_login.dart';
import 'package:attenda/register/business_logic/register_cubit.dart';
import 'package:attenda/students/business_logic/add_student_cubit/add_student_cubit.dart';
import 'package:attenda/students/models/students_model.dart';
import 'package:attenda/students/view/screens/edit_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../students/view/screens/new_student_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeLoginRoute:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider(create: (_) => HomeLoginCubit()),
                  BlocProvider(create: (_) => RegisterCubit()),
                  BlocProvider(create: (_) => LoginCubit()),
                ], child: HomeLogin()));
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => BlocProvider(create: (_)=>HomeCubit(),child: const HomeScreen()));
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
    }
    return null;
  }
}
