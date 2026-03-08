import 'dart:async';

import 'package:ev_products_app/core/network/network_connection_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectivityStatus { online, offline }

/// Puente global de estado de conectividad para reacciones de UI.
class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final NetworkConnectionService networkConnectionService;
  StreamSubscription<bool>? _subscription;

  ConnectivityCubit(this.networkConnectionService)
    : super(ConnectivityStatus.online) {
    // Mantiene el estado alineado con cambios de interfaz de red.
    _subscription = networkConnectionService.onConnectionChanged.listen((isUp) {
      emit(isUp ? ConnectivityStatus.online : ConnectivityStatus.offline);
    });

    // Sondeo inicial para no depender del primer evento del stream.
    unawaited(checkNow());
  }

  /// Sondeo manual usado por acciones de reintento desde la UI.
  Future<void> checkNow() async {
    final isUp = await networkConnectionService.isConnected();
    emit(isUp ? ConnectivityStatus.online : ConnectivityStatus.offline);
  }

  @override
  Future<void> close() async {
    // Importante cuando el ciclo de vida lo gestiona un provider.
    await _subscription?.cancel();
    return super.close();
  }
}
