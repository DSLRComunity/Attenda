import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'center_history_state.dart';

class CenterHistoryCubit extends Cubit<CenterHistoryState> {
  CenterHistoryCubit() : super(CenterHistoryInitial());
}
