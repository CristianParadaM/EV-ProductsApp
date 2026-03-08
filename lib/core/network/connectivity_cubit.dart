import 'dart:async';

import 'package:ev_products_app/core/network/network_connection_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final NetworkConnectionService networkConnectionService;
  StreamSubscription<bool>? _subscription;

  ConnectivityCubit(this.networkConnectionService)
    : super(ConnectivityStatus.online) {
    _subscription = networkConnectionService.onConnectionChanged.listen((isUp) {
      emit(isUp ? ConnectivityStatus.online : ConnectivityStatus.offline);
    });

    unawaited(checkNow());
  }

  Future<void> checkNow() async {
    final isUp = await networkConnectionService.isConnected();
    emit(isUp ? ConnectivityStatus.online : ConnectivityStatus.offline);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
