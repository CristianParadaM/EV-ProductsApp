import 'dart:math';
import 'dart:typed_data';

import 'package:argon2/argon2.dart';

class PasswordHasher {
  PasswordHasher._();

  static const String _algorithm = 'argon2id';
  static const int _version = Argon2Parameters.ARGON2_VERSION_13;
  static const int _memory = 65536;
  static const int _iterations = 3;
  static const int _lanes = 1;
  static const int _saltLength = 16;
  static const int _hashLength = 32;

  static String hashPassword(String password) {
    final salt = _generateSalt();
    final hash = _deriveHash(password: password, salt: salt);

    return '$_algorithm\$v=$_version\$m=$_memory,t=$_iterations,p=$_lanes\$${salt.toHexString()}\$${hash.toHexString()}';
  }

  static bool verifyPassword({
    required String password,
    required String encodedHash,
  }) {
    final parts = encodedHash.split(r'$');
    if (parts.length != 5 || parts[0] != _algorithm) {
      return false;
    }

    final version = _parseVersion(parts[1]);
    final params = _parseParams(parts[2]);
    final salt = _hexToBytes(parts[3]);
    final expectedHash = _hexToBytes(parts[4]);

    if (version == null || params == null || salt == null || expectedHash == null) {
      return false;
    }

    final computedHash = _deriveHash(
      password: password,
      salt: salt,
      memory: params.memory,
      iterations: params.iterations,
      lanes: params.lanes,
      version: version,
      outputLength: expectedHash.length,
    );

    return _constantTimeEquals(computedHash, expectedHash);
  }

  static Uint8List _deriveHash({
    required String password,
    required Uint8List salt,
    int memory = _memory,
    int iterations = _iterations,
    int lanes = _lanes,
    int version = _version,
    int outputLength = _hashLength,
  }) {
    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      Uint8List.fromList(salt),
      memory: memory,
      iterations: iterations,
      lanes: lanes,
      version: version,
    );

    final generator = Argon2BytesGenerator()..init(parameters);
    final result = Uint8List(outputLength);
    final passwordBytes = parameters.converter.convert(password);
    generator.generateBytes(passwordBytes, result, 0, result.length);

    return result;
  }

  static Uint8List _generateSalt() {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(_saltLength, (_) => random.nextInt(256)),
    );
  }

  static int? _parseVersion(String value) {
    if (!value.startsWith('v=')) {
      return null;
    }
    return int.tryParse(value.substring(2));
  }

  static _Argon2Params? _parseParams(String value) {
    final chunks = value.split(',');
    if (chunks.length != 3) {
      return null;
    }

    final map = <String, int>{};
    for (final chunk in chunks) {
      final pair = chunk.split('=');
      if (pair.length != 2) {
        return null;
      }
      final parsed = int.tryParse(pair[1]);
      if (parsed == null) {
        return null;
      }
      map[pair[0]] = parsed;
    }

    final memory = map['m'];
    final iterations = map['t'];
    final lanes = map['p'];

    if (memory == null || iterations == null || lanes == null) {
      return null;
    }

    return _Argon2Params(memory: memory, iterations: iterations, lanes: lanes);
  }

  static Uint8List? _hexToBytes(String hex) {
    if (hex.length.isOdd) {
      return null;
    }

    final bytes = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < hex.length; i += 2) {
      final byte = int.tryParse(hex.substring(i, i + 2), radix: 16);
      if (byte == null) {
        return null;
      }
      bytes[i ~/ 2] = byte;
    }

    return bytes;
  }

  static bool _constantTimeEquals(Uint8List a, Uint8List b) {
    if (a.length != b.length) {
      return false;
    }

    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}

class _Argon2Params {
  const _Argon2Params({
    required this.memory,
    required this.iterations,
    required this.lanes,
  });

  final int memory;
  final int iterations;
  final int lanes;
}
