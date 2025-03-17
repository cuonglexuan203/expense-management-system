class ApiEndpoints {
  static const String base = '/api/v1';

  static final auth = _AuthEndpoints();
  static final category = _CategoryEndpoints();
  static final developer = _DeveloperEndpoints();
  static final transaction = _TransactionEndpoints();
  static final wallet = _WalletEndpoints();
}

class _AuthEndpoints {
  final String base = '${ApiEndpoints.base}/auth';
  String get register => '$base/register';
  String get login => '$base/login';
  String get refreshToken => '$base/refresh-token';
  String get logout => '$base/logout';
}

class _CategoryEndpoints {
  final String base = '${ApiEndpoints.base}/categories';
  String get getAll => base;
  String get create => base;
  String getById(String id) => '$base/$id';
  String update(String id) => '$base/$id';
  String delete(String id) => '$base/$id';
}

class _DeveloperEndpoints {
  final String base = '${ApiEndpoints.base}/developer';
  String get ping => '$base/ping';
  String get systemSettings => '$base/system-settings';
}

class _TransactionEndpoints {
  final String base = '${ApiEndpoints.base}/transactions';
  String get getAll => base;
  String getById(String id) => '$base/$id';
  String get create => base;
}

class _WalletEndpoints {
  final String base = '${ApiEndpoints.base}/wallets';
  String get getAll => base;
  String get create => base;
  String getById(String id) => '$base/$id';
  String update(String id) => '$base/$id';
  String get walletSummary => '$base/wallet-summary';
}
