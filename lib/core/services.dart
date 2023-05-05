import 'package:attenda/core/network/connection.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final sl = GetIt.instance;
class ServiceLocator {
  void init() {
    sl.registerLazySingleton<Connectivity>(() => Connectivity());
    sl.registerLazySingleton<ConnectionStatus>(() => ConnectionStatus(sl()));
  }
}
