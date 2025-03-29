class ApiEndpoints {
  static const String base = '/api/v1';

  static final auth = _AuthEndpoints();
  static final category = _CategoryEndpoints();
  static final developer = _DeveloperEndpoints();
  static final transaction = _TransactionEndpoints();
  static final wallet = _WalletEndpoints();
  static final chatThread = _ChatThreadEndpoints();
  static final extractedTransaction = _ExtractedTransactionEndpoints();
  static final hubConnection = _HubConnectionEndpoints();
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

class _ChatThreadEndpoints {
  final String base = '${ApiEndpoints.base}/chat-threads';
  String get getAll => base;
  String getById(String id) => '$base/$id';
  String getMessageById(int id) => '$base/$id/messages';
}

class _ExtractedTransactionEndpoints {
  final String base = '${ApiEndpoints.base}/extracted-transactions';
  String confirmTransaction(int id) => '$base/$id/confirm';
  String confirmStatusTransaction(int id) => '$base/$id/status';
}

class _HubConnectionEndpoints {
  final String base = '$ApiEndpoints/hubs';
  String get finance => '$base/finance';
}
