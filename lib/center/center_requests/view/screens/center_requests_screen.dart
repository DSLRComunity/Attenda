import 'package:attenda/center/center_requests/buiness_logic/center_requests_cubit/center_requests_cubit.dart';
import 'package:attenda/center/center_requests/models/cener_request_model.dart';
import 'package:attenda/center/center_requests/view/widgets/request_item.dart';
import 'package:attenda/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CenterRequestsScreen extends StatefulWidget {
  const CenterRequestsScreen({Key? key}) : super(key: key);

  @override
  State<CenterRequestsScreen> createState() => _CenterRequestsScreenState();
}

class _CenterRequestsScreenState extends State<CenterRequestsScreen> {
  @override
  void initState() {
    CenterRequestsCubit.get(context)
        .pagingController
        .addPageRequestListener((pageKey) {
      CenterRequestsCubit.get(context).fetchPage(pageKey,context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CenterRequestsCubit,CenterRequestsState>(
      builder: (context, state) {
        return PagedListView<int, CenterRequestModel>(
            pagingController: CenterRequestsCubit.get(context).pagingController,
            builderDelegate: PagedChildBuilderDelegate<CenterRequestModel>(
                itemBuilder: (context, item, index) => RequestItem(model: item),
                firstPageProgressIndicatorBuilder: (_) => const Center(
                    child: CircularProgressIndicator(color: MyColors.primary)),
                firstPageErrorIndicatorBuilder: (context) {
                  CenterRequestsCubit.get(context).pagingController.refresh();
                  return Center(
                      child: Text(
                          '${CenterRequestsCubit.get(context).pagingController.error}'));
                },
                newPageProgressIndicatorBuilder: (_) => const Center(
                  child: CircularProgressIndicator(
                    color: MyColors.primary,
                  ),
                )));
      },
    );
  }
}
