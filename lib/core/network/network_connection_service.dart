import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Reporta alcance real a internet, no solo disponibilidad de interfaz.
///
/// `connectivity_plus` indica tipo de red (wifi/mobile), pero eso no garantiza
/// salida a internet. Este servicio agrega una prueba de resolucion DNS.
class NetworkConnectionService {
  final Connectivity _connectivity;

  NetworkConnectionService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  Stream<bool> get onConnectionChanged {
    // Revalida conectividad real en cada cambio de interfaz.
    return _connectivity.onConnectivityChanged.asyncMap((_) => isConnected());
  }

  /// Usa una verificacion en dos pasos:
  /// 1) existe al menos una interfaz de red
  /// 2) la consulta DNS responde (internet probablemente disponible)
  Future<bool> isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final hasNetworkInterface = !connectivityResult.contains(
      ConnectivityResult.none,
    );

    if (!hasNetworkInterface) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      // Cualquier fallo de socket se trata como offline para UI deterministica.
      return false;
    }
  }
}
