import 'package:flutter/material.dart';

extension SnackbarCustom on BuildContext {
  void showSuccess(String msg, {Duration? duration, EdgeInsets? margin}) {
    _showSnack(msg, Colors.green.shade700, Icons.check_circle, duration: duration, margin: margin);
  }

  void showError(String msg, {Duration? duration, EdgeInsets? margin}) {
    _showSnack(msg, Colors.red.shade700, Icons.error, duration: duration, margin: margin);
  }

  void showInfo(String msg, {Duration? duration, EdgeInsets? margin}) {
    _showSnack(msg, Colors.blue.shade700, Icons.info, duration: duration, margin: margin);
  }

  void showWarning(String msg, {Duration? duration, EdgeInsets? margin}) {
    _showSnack(msg, Colors.orange.shade700, Icons.warning, duration: duration, margin: margin);
  }

  void _showSnack(
    String msg,
    Color color,
    IconData icon, {
    Duration? duration,
    EdgeInsets? margin,
    SnackBarAction? action,
    DismissDirection? dismissDirection,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: margin ?? const EdgeInsets.all(16),
          duration: duration ?? const Duration(seconds: 3),
          dismissDirection: dismissDirection ?? DismissDirection.horizontal,
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(msg, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
          action: action,
        ),
      );
  }

  void showOfflineSnackBar(String msg, {VoidCallback? onRetry, Duration? duration, EdgeInsets? margin, DismissDirection? dismissDirection}) {
    _showSnack(
      msg,
      Colors.brown,
      Icons.cloud_off,
      duration: duration ?? const Duration(days: 1),
      margin: margin ?? const EdgeInsets.all(16),
      dismissDirection: dismissDirection ?? DismissDirection.none,
      action: onRetry != null
          ? SnackBarAction(
              label: 'Entendido',
              textColor: Colors.white,
              onPressed: onRetry,
            )
          : null,
    );
  }

  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  void showConnectedSnackBar() {
    _showSnack(
      'Conexión restablecida',
      Colors.green.shade700,
      Icons.wifi,
      duration: const Duration(seconds: 2),
    );
  }
}
