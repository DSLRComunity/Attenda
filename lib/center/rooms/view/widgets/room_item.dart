import 'package:attenda/center/rooms/models/room_model.dart';
import 'package:attenda/classes/view/widgets/class_card_info.dart';
import 'package:attenda/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomItem extends StatelessWidget {
  const RoomItem({Key? key,required this.room}) : super(key: key);
final RoomModel room;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.pushNamed(context, Routes.roomDetails,arguments: room);
      },
      child: Card(
        color:  const Color(0xff568466),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.w)),
          ),
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClassCardInfo(
                          title: 'Room Name: ',
                          value: room.name,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.delete,color: Colors.white,))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
