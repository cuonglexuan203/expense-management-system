import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityNotifier extends StateNotifier<ConnectionState> {
  ConnectivityNotifier() : super(ConnectionState.online) {
    _initConnectivity();
    _setupConnectivityListener();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;
  bool _isCheckingConnection = false;
  Timer? _debounceTimer;

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result.isNotEmpty) {
        _updateConnectionStatus(result.first);
      } else {
        state = ConnectionState.offline;
      }
    } catch (e) {
      log('Error checking initial connectivity: $e');
      state = ConnectionState.offline;
    }
  }

  void _setupConnectivityListener() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        if (results.isNotEmpty) {
          _updateConnectionStatus(results.first);
        } else {
          state = ConnectionState.offline;
        }
      });
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (_isCheckingConnection) return;
    _isCheckingConnection = true;

    try {
      if (result == ConnectivityResult.none) {
        state = ConnectionState.offline;
      } else {
        if (state == ConnectionState.offline) {
          final hasRealConnection = await _checkRealConnection();
          state = hasRealConnection
              ? ConnectionState.online
              : ConnectionState.offline;
        } else {
          state = ConnectionState.online;
        }
      }
    } finally {
      _isCheckingConnection = false;
    }

    log('Connection status: ${state.name}');
  }

  Future<bool> _checkRealConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> checkConnection() async {
    if (state == ConnectionState.offline) return false;

    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isEmpty || results.first == ConnectivityResult.none)
        return false;

      return _checkRealConnection();
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectionState>((ref) {
  return ConnectivityNotifier();
});
