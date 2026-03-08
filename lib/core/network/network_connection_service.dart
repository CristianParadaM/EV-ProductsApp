import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectionService {
  final Connectivity _connectivity;

  NetworkConnectionService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  Stream<bool> get onConnectionChanged {
    return _connectivity.onConnectivityChanged.asyncMap((_) => isConnected());
  }

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
      return false;
    }
  }
}
