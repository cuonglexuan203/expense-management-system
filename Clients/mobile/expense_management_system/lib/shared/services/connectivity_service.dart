// lib/shared/services/connectivity_service.dart
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityService {
  final _connectivity = Connectivity();
  final _controller = StreamController<ConnectivityStatus>.broadcast();
  StreamSubscription? _connectivitySubscription;

  ConnectivityService() {
    _init();
  }

  Stream<ConnectivityStatus> get statusStream => _controller.stream;

  Future<void> _init() async {
    // Kiểm tra trạng thái kết nối khởi tạo
    await _checkConnectionAndNotify();

    // Thiết lập lắng nghe thay đổi kết nối
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((_) async {
      await _checkConnectionAndNotify();
    });
  }

  // Kiểm tra thực tế kết nối internet và thông báo thay đổi
  Future<void> _checkConnectionAndNotify() async {
    final status = await isConnected()
        ? ConnectivityStatus.online
        : ConnectivityStatus.offline;
    _controller.add(status);
    log('Connectivity status: $status');
  }

  // Kiểm tra kết nối thực tế bằng cách ping Google
  Future<bool> isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();

    // Nếu không có kết nối mạng cơ bản
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Thử kết nối thực tế
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _controller.close();
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.statusStream;
});
