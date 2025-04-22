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
  static final media = _MediaEndpoints();
  static final user = _UserEndpoints();
  static final devicesToken = _DevicesToken();
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
  String get getDefault => '$base/defaults';
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

class _MediaEndpoints {
  final String base = '${ApiEndpoints.base}/medias';
  String uploadFile(int id) => '$base/messages/$id';
}

// class _NotificationEndpoints {
//   final String base = '${ApiEndpoints.base}/notifications';
//   String get getAll => base;
//   String getById(String id) => '$base/$id';
//   String markAsRead(String id) => '$base/$id/mark-as-read';
//   String delete(String id) => '$base/$id';
// }

class _UserEndpoints {
  final String base = '${ApiEndpoints.base}/onboarding';
  String get onboarding => base;
  String get getOnboardingStatus => '$base/status';
  String get getLanguages => '$base/languages';
  String get getCurrencies => '$base/currencies';
}

class _DevicesToken {
  final String base = '${ApiEndpoints.base}/device-tokens';
  String get registerToken => base;
  String getTokenByUserId(String userId) => '$base/users/$userId';
}
