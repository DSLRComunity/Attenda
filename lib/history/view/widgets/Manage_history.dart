import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../classes/view/widgets/toast.dart';
import '../../../core/colors.dart';
import '../../business_logic/history_cubit.dart';
import 'history_item.dart';

class ManageHistory extends StatefulWidget {
  const ManageHistory({Key? key}) : super(key: key);

  @override
  State<ManageHistory> createState() => _ManageHistoryState();
}

class _ManageHistoryState extends State<ManageHistory> {
  void _getInit()async{
    if(HistoryCubit.get(context).manageHistory.isEmpty){
      await HistoryCubit.get(context).getManageHistory();
    }
  }
@override
  void initState() {
_getInit();
super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<HistoryCubit, HistoryState>(
      buildWhen: (previous, current) => (current is GetManageHistoryLoad ||
          current is GetManageHistorySuccess ||
          current is GetManageHistoryError),
      listenWhen:(previous, current) => current is GetManageHistoryError,
      builder: (context, state) {
        if(state is GetManageHistoryLoad){
          return const Center(child: CircularProgressIndicator(),);
        }else{
          return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return HistoryItem(
                  message:
                  HistoryCubit.get(context).manageHistory[index].message,
                  date: HistoryCubit.get(context).manageHistory[index].date,
                );
              },
              separatorBuilder: (context, index) =>
              const Divider(color: MyColors.grey),
              itemCount: HistoryCubit.get(context).manageHistory.length);
        }
      },
      listener: (context, state) {
        if(state is GetManageHistoryError){
          showErrorToast(context: context, message: 'Error try again');
        }
      },
    );
  }
}
