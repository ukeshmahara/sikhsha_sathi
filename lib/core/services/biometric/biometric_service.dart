import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Whether this device has usable biometric hardware (fingerprint, face) —
  /// AND the user has actually enrolled at least one biometric with the OS.
  Future<bool> canCheckBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheck && isDeviceSupported;
    } catch (_) {
      return false;
    }
  }

  /// Shows the OS fingerprint/face prompt. Returns true only if the user
  /// actually authenticated successfully.
  Future<bool> authenticate({
    String reason = 'Scan your fingerprint to log in',
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true, // was called stickyAuth in older versions
      );
    } catch (_) {
      return false;
    }
  }
}