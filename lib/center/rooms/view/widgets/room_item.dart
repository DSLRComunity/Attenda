import 'package:attenda/center/new_room/models/room_model.dart';
import 'package:attenda/classes/view/widgets/class_card_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomItem extends StatelessWidget {
  const RoomItem({Key? key,required this.room}) : super(key: key);
final RoomModel room;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
      },
      child: Card(
        color:  Color(room.color),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClassCardInfo(
                        title: 'Room Name: ',
                        value: room.roomNum,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                      SizedBox(
                        height: 7.h,
                      ),
                      ClassCardInfo(
                          title: 'Max Size: ',
                          value: room.maxSize.toString(),),
                      SizedBox(
                        height: 5.h,
                      ),
                      ClassCardInfo(
                          title: 'fee method: ', value: room.feeMethod),
                      SizedBox(
                        height: 5.h,
                      ),
                      ClassCardInfo(
                          title: 'price: ', value: room.price.toString()),
                      SizedBox(
                        height: 5.h,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
