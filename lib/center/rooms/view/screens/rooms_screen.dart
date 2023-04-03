import 'package:attenda/center/center_home/business_logic/center_home_cubit/center_home_cubit.dart';
import 'package:attenda/center/new_room/business_logic/add_room_cubit.dart';
import 'package:attenda/center/new_room/view/room_dialog.dart';
import 'package:attenda/center/rooms/business_logic/rooms_cubit.dart';
import 'package:attenda/center/rooms/view/widgets/rooms_grid_view.dart';
import 'package:attenda/classes/view/widgets/custom_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({Key? key}) : super(key: key);

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final _scrollController = ScrollController();

  void _getRooms() async {
    await RoomsCubit.get(context).getRooms();
  }

  @override
  void initState() {
    if (RoomsCubit.get(context).rooms.isEmpty) {
      _getRooms();
    }
    print('roooommsss');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: ImprovedScrolling(
        scrollController: _scrollController,
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
          controller: _scrollController,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: CustomButton(
                  text: 'Add Room',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => BlocProvider(
                            create: (context) => AddRoomCubit(),
                            child: const RoomDialog()));
                  },
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              RoomsCubit.get(context).rooms == []
                  ? Center(
                      child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                '${(kDebugMode && kIsWeb) ? "" : "assets/"}images/empty.gif')),
                      ),
                    ))
                  : const RoomsGridView(),
            ],
          ),
        ),
      ),
    );
  }
}
