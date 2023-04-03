import 'package:attenda/center/rooms/business_logic/rooms_cubit.dart';
import 'package:attenda/center/rooms/view/widgets/room_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomsGridView extends StatefulWidget {
  const RoomsGridView({Key? key}) : super(key: key);

  @override
  State<RoomsGridView> createState() => _RoomsGridViewState();
}

class _RoomsGridViewState extends State<RoomsGridView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomsCubit,RoomsState>(
      buildWhen: (previous, current) => current is GetRoomsSuccess ||current is GetRoomsLoad || current is GetRoomsError,
      builder: (context, state) {
        if(RoomsCubit.get(context).rooms==[]){
          return const Center(child: CircularProgressIndicator(),);
        }else {
          return GridView.count(
            crossAxisCount: 5,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 5.h,
            crossAxisSpacing: 5.w,
            scrollDirection: Axis.vertical,
            childAspectRatio: 1.w / 2.h,
            children: RoomsCubit.get(context)
                .rooms
                .map((c) => RoomItem(room: c,))
                .toList(),
          );
        }
      },
    );
  }
}
