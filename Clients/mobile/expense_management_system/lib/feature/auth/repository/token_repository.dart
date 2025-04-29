import 'package:expense_management_system/feature/auth/model/token.dart';
import 'package:expense_management_system/shared/constants/store_key.dart';
import 'package:expense_management_system/shared/util/platform_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenRepositoryProtocol {
  Future<void> remove();
  Future<void> saveToken(Token token);
  Future<Token?> fetchToken();
  Future<String?> getAccessToken();
}

final tokenRepositoryProvider = Provider(TokenRepository.new);

class TokenRepository implements TokenRepositoryProtocol {
  TokenRepository(this._ref);

  late final PlatformType _platform = _ref.read(platformTypeProvider);
  final Ref _ref;
  Token? _token;

  @override
  Future<void> remove() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();

    // if (_platform == PlatformType.iOS ||
    //     _platform == PlatformType.android ||
    //     _platform == PlatformType.linux) {
    //   const storage = FlutterSecureStorage();
    //   try {
    //     await storage.delete(key: StoreKey.token.toString());
    //   } on Exception catch (e) {}
    // } else {
    //   await prefs.remove(StoreKey.token.toString());
    // }
    await prefs.remove(StoreKey.token.toString());

    await prefs.remove(StoreKey.user.toString());
  }

  @override
  Future<void> saveToken(Token token) async {
    _token = token;

    // if (_platform == PlatformType.iOS ||
    //     _platform == PlatformType.android ||
    //     _platform == PlatformType.linux) {
    //   const storage = FlutterSecureStorage();
    //   final key = StoreKey.token.toString();
    //   final value = tokenToJson(token);
    //   try {
    //     print('[TEST] TokenRepository: Attempting to save token with key: $key (Using SecureStorage)');
    //     await storage.write(key: key, value: value);
    //     print('[TEST] TokenRepository: $value');
    //     print('[TEST] TokenRepository: Successfully saved token (Using SecureStorage).');
    //   } on Exception catch (e) {
    //     print('[TEST] TokenRepository: !!! ERROR saving token (Using SecureStorage): $e');
    //   }
    // } else {
    //   await prefs.setString(StoreKey.token.toString(), tokenToJson(token));
    // }

    final prefs = await SharedPreferences.getInstance();
    final key = StoreKey.token.toString();
    final value = tokenToJson(token);
    try {
      await prefs.setString(key, value);
    } on Exception catch (e) {
      print(
          'TokenRepository: !!! ERROR saving token (Using SharedPreferences): $e');
    }
  }

  @override
  Future<Token?> fetchToken() async {
    if (_token != null) {
      return _token;
    }

    String? tokenValue;

    // if (_platform == PlatformType.iOS ||
    //     _platform == PlatformType.android ||
    //     _platform == PlatformType.linux) {
    //   const storage = FlutterSecureStorage();
    //   tokenValue = await storage.read(key: StoreKey.token.toString());
    // } else {
    //   final prefs = await SharedPreferences.getInstance();
    //   tokenValue = prefs.getString(StoreKey.token.toString());
    // }
    final prefs = await SharedPreferences.getInstance();
    tokenValue = prefs.getString(StoreKey.token.toString());

    try {
      if (tokenValue != null) {
        _token = tokenFromJson(tokenValue);
      }
    } on Exception catch (e) {
      print('TokenRepository: Error parsing fetched token: $e');
    }

    return _token;
  }

  @override
  Future<String?> getAccessToken() async {
    final token = await fetchToken();
    return token?.accessToken;
  }
}
