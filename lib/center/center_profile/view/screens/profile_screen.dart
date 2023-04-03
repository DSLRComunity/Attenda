import 'package:attenda/center/center_home/business_logic/center_home_cubit/center_home_cubit.dart';
import 'package:attenda/center/center_appointments/models/event_model.dart';
import 'package:attenda/center/center_profile/business_logic/profile_cubit.dart';
import 'package:attenda/classes/view/widgets/toast.dart';
import 'package:attenda/core/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CenterProfileScreen extends StatefulWidget {
  const CenterProfileScreen({Key? key,required this.centerHomeCubit}) : super(key: key);
final CenterHomeCubit centerHomeCubit;
  @override
  State<CenterProfileScreen> createState() => _CenterProfileScreenState();
}

class _CenterProfileScreenState extends State<CenterProfileScreen> {
  void _getData()async{
   await ProfileCubit.get(context).getCenterData();
  }
  @override
  void initState() {
    _getData();
    super.initState();
  }

  DateTime initialDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit,ProfileState>(
      listenWhen: (previous, current) => (current is GetCenterDataError),
      listener: (context, state) {
        if(state is GetCenterDataError){
          showErrorToast(context: context, message: 'Error, try again');
        }
      },
      builder: (context, state) {
        var cubit = ProfileCubit.get(context);
        if(state is GetCenterDataLoad){
          return const Center(child: CircularProgressIndicator(),);
        }else if(state is GetCenterDataError){
          return Container();
        }else {
          if(kDebugMode){
            print('profile////////////////////');
          }
          return  Scaffold(
            body: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: MyColors.black
                  ),
                  height: MediaQuery.of(context).size.height * .27,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                    child: LayoutBuilder(
                      builder: (context, constraints) => Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${cubit.centerData!.centerName} Center',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                                ),
                                SizedBox(height: 5.h,),
                                Text(
                                  cubit.centerData!.info,
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 20.w,),
                          Expanded(child: Column(
                            children: [
                              Row(
                                children:  [
                                  const Icon(Icons.info_outline,color: MyColors.primary,),
                                  SizedBox(width: 3.w,),
                                  Text('About',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white)),
                                ],
                              ),
                              SizedBox(height: 15.h,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileInfo(title: 'Address', icon: Icons.location_on_outlined, info:cubit.centerData!.location),
                                    ProfileInfo(title: 'Phone Number', icon: Icons.phone, info: cubit.centerData!.phone),
                                    ProfileInfo(title: 'Email', icon: Icons.email_outlined, info: cubit.centerData!.email),
                                    InkWell(onTap: (){},child: const ProfileInfo(title: 'Chat us', icon: Icons.chat, info: '')),
                                  ],
                                ),
                              ),

                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SfCalendar(
                    view: CalendarView.week,
                    firstDayOfWeek: 6,
                    showNavigationArrow: true,
                    showDatePickerButton: true,
                    initialDisplayDate: DateTime(initialDate.year,initialDate.month,initialDate.day,9,0,0 ),
                    dataSource: EventDataSource(widget.centerHomeCubit.makeAppointment(teacherView: true)),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({Key? key,required this.title,required this.icon,required this.info}) : super(key: key);
  final String title;
  final String info;
  final IconData icon;


  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Icon(icon,color: MyColors.primary),
        SizedBox(width: 2.w,),
        Text(title,style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),overflow: TextOverflow.ellipsis,maxLines: 2,),
        SizedBox(width: 5.w,),
        Text(info,style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),maxLines: 2,),
      ],
    );
  }
}

