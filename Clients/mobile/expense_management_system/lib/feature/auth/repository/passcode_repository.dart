// lib/feature/auth/repository/passcode_repository.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math' hide log;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:developer';

part 'passcode_repository.g.dart';

@riverpod
PasscodeRepository passcodeRepository(PasscodeRepositoryRef ref) {
  return PasscodeRepository();
}

class PasscodeRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _passcodeHashKey = 'passcode_hash';
  static const String _passcodeSaltKey = 'passcode_salt';
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _lastVerificationTimeKey = 'last_verification_time';
  static const String _failedAttemptsKey = 'failed_passcode_attempts';
  static const String _biometricsEnabledKey = 'biometrics_enabled';
  static const String _appWasBackgroundedKey = 'app_was_backgrounded';
  static const int _lockoutThreshold = 5;

  // Set this to a lower value like 10 seconds for testing, then change to 5 minutes for production
  static final int _autoLockTimeoutSeconds = dotenv.env['TIMEOUT'] != null
      ? int.parse(dotenv.env['TIMEOUT']!)
      : 300; // Default to 5 minutes

  Future<void> setPasscode(String passcode) async {
    log("Setting new passcode");
    final salt = _generateSalt();
    final saltBase64 = base64Encode(salt);

    // Hash the passcode with the salt
    final bytes = utf8.encode(passcode);
    final combinedBytes = [...bytes, ...salt];
    final hash = sha256.convert(combinedBytes).toString();

    // Store hash and salt securely
    await _secureStorage.write(key: _passcodeHashKey, value: hash);
    await _secureStorage.write(key: _passcodeSaltKey, value: saltBase64);

    // Reset failed attempts
    await _secureStorage.write(key: _failedAttemptsKey, value: '0');

    // Update verification time
    await updateVerificationTime();
  }

  List<int> _generateSalt() {
    final random = Random.secure();
    return List<int>.generate(32, (_) => random.nextInt(256));
  }

  Future<bool> verifyPasscode(String enteredPasscode) async {
    log("Verifying passcode");
    final hash = await _secureStorage.read(key: _passcodeHashKey);
    final saltBase64 = await _secureStorage.read(key: _passcodeSaltKey);

    if (hash == null || saltBase64 == null) {
      log("No passcode hash or salt found");
      return false;
    }

    final salt = base64Decode(saltBase64);
    final bytes = utf8.encode(enteredPasscode);
    final combinedBytes = [...bytes, ...salt];
    final enteredHash = sha256.convert(combinedBytes).toString();

    final isCorrect = hash == enteredHash;
    if (isCorrect) {
      log("Passcode verified successfully");
      await resetFailedAttempts();
      await updateVerificationTime();
    } else {
      log("Incorrect passcode entered");
      await incrementFailedAttempts();
    }

    return isCorrect;
  }

  Future<void> updateVerificationTime() async {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    await _secureStorage.write(key: _lastVerificationTimeKey, value: now);
    log("Updated verification timestamp: $now");
  }

  Future<void> incrementFailedAttempts() async {
    final attemptsStr =
        await _secureStorage.read(key: _failedAttemptsKey) ?? '0';
    final attempts = int.parse(attemptsStr) + 1;
    await _secureStorage.write(
        key: _failedAttemptsKey, value: attempts.toString());
    log("Failed attempts incremented to: $attempts");
  }

  Future<void> resetFailedAttempts() async {
    await _secureStorage.write(key: _failedAttemptsKey, value: '0');
    log("Failed attempts reset to 0");
  }

  Future<int> getFailedAttempts() async {
    final attemptsStr =
        await _secureStorage.read(key: _failedAttemptsKey) ?? '0';
    final attempts = int.parse(attemptsStr);
    log("Current failed attempts: $attempts");
    return attempts;
  }

  Future<bool> isLockedOut() async {
    final attempts = await getFailedAttempts();
    final isLocked = attempts >= _lockoutThreshold;
    log("Is account locked due to failed attempts: $isLocked ($attempts/$_lockoutThreshold)");
    return isLocked;
  }

  Future<bool> isPasscodeSet() async {
    final hash = await _secureStorage.read(key: _passcodeHashKey);
    final isSet = hash != null && hash.isNotEmpty;
    log("Is passcode set: $isSet");
    return isSet;
  }

  Future<void> setAppWasBackgrounded() async {
    await _secureStorage.write(key: _appWasBackgroundedKey, value: 'true');
    log("App marked as backgrounded");
  }

  Future<void> clearAppBackgroundedFlag() async {
    await _secureStorage.write(key: _appWasBackgroundedKey, value: 'false');
    log("App backgrounded flag cleared");
  }

  Future<bool> wasAppKilledFromRecents() async {
    final wasBackgrounded =
        await _secureStorage.read(key: _appWasBackgroundedKey);

    if (wasBackgrounded == null) {
      log("App was not previously backgrounded (first launch)");
      return false;
    }

    final wasKilled = wasBackgrounded == 'true';
    log("Was app killed from recents: $wasKilled");

    if (wasKilled) {
      await clearAppBackgroundedFlag();
    }

    return wasKilled;
  }

  Future<bool> shouldRequirePasscode() async {
    // First check if a passcode exists
    if (!await isPasscodeSet()) {
      log("No passcode set, not requiring verification");
      return false;
    }

    if (await wasAppKilledFromRecents()) {
      log("App was killed from recents, requiring passcode");
      return true;
    }

    // Then check when it was last verified
    final lastVerificationStr =
        await _secureStorage.read(key: _lastVerificationTimeKey);
    if (lastVerificationStr == null) {
      log("No verification timestamp, requiring passcode");
      return true;
    }

    final lastVerification = int.parse(lastVerificationStr);
    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsedSeconds = (now - lastVerification) ~/ 1000;

    final shouldRequire = elapsedSeconds > _autoLockTimeoutSeconds;
    log("Time since last verification: ${elapsedSeconds}s, timeout: ${_autoLockTimeoutSeconds}s");
    log("Should require passcode: $shouldRequire");

    return shouldRequire;
  }

  Future<void> setOnboardingCompleted() async {
    log("Marking onboarding as completed");
    await _secureStorage.write(key: _onboardingCompletedKey, value: 'true');
  }

  Future<bool> hasCompletedOnboarding() async {
    final completed = await _secureStorage.read(key: _onboardingCompletedKey);
    final hasCompleted = completed == 'true';
    log("Has completed onboarding: $hasCompleted");
    return hasCompleted;
  }

  Future<bool> isBiometricsEnabled() async {
    final enabled = await _secureStorage.read(key: _biometricsEnabledKey);
    final result = enabled == 'true';
    log("Biometrics enabled status: $result (raw value: $enabled)");
    return result;
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    log("Setting biometrics enabled: $enabled");
    await _secureStorage.write(
        key: _biometricsEnabledKey, value: enabled ? 'true' : 'false');

    // Verify that it was set correctly
    final verifyEnabled = await _secureStorage.read(key: _biometricsEnabledKey);
    log("Biometrics enabled set to: $verifyEnabled");
  }
}
