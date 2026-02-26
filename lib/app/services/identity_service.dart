import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/api.dart' as crypto;

class IdentityService {
  static final IdentityService instance = IdentityService._internal();

  IdentityService._internal();

  String base64UrlDecode(String input) {
    String base64 = input.replaceAll('-', '+').replaceAll('_', '/');
    int mod4 = base64.length % 4;
    if (mod4 > 0) {
      base64 += '=' * (4 - mod4);
    }
    final bytes = base64Decode(base64);
    return utf8.decode(bytes);
  }

  TokenPayload parseJwt(String jwt) {
    final parts = jwt.split('.');
    if (parts.length != 3) {
      throw ArgumentError('Invalid JWT');
    }

    final payloadJson = base64UrlDecode(parts[1]);
    final Map<String, dynamic> payload = jsonDecode(payloadJson);

    return TokenPayload.fromJson(payload);
  }

  String encryptAES(String? plaintext) {
    if (plaintext == null || plaintext.isEmpty) {
      return '';
    }

    final plaintextBytes = Uint8List.fromList(utf8.encode(plaintext));
    const secretKey = 'v973S^3EWd#&ZVz*UgA8xzB*CDF7kPA2';
    final key = Uint8List.fromList(utf8.encode(secretKey.padRight(32, ' ')));
    final iv = Uint8List(16); // 16-byte IV for AES
    final cipher = crypto.PaddedBlockCipher("AES/CBC/PKCS7");
    final keyParam = crypto.KeyParameter(key);
    final ivParam = crypto.ParametersWithIV<crypto.KeyParameter>(keyParam, iv);
    final params = crypto.PaddedBlockCipherParameters<crypto.CipherParameters,
        crypto.CipherParameters>(ivParam, null);
    cipher.init(true, params); // true for encryption mode
    final encryptedBytes = cipher.process(plaintextBytes);
    return base64.encode(encryptedBytes);
  }

  String decryptAES(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return '';
    }

    final encryptedBytes = base64.decode(base64String);
    const secretKey = 'v973S^3EWd#&ZVz*UgA8xzB*CDF7kPA2';
    final key = Uint8List.fromList(utf8.encode(secretKey.padRight(32, ' ')));
    final iv = Uint8List(16); // 16-byte IV (Initialization Vector)
    final cipher = crypto.PaddedBlockCipher("AES/CBC/PKCS7");
    final keyParam = crypto.KeyParameter(key);
    final ivParam = crypto.ParametersWithIV<crypto.KeyParameter>(keyParam, iv);
    final params = crypto.PaddedBlockCipherParameters<crypto.CipherParameters,
        crypto.CipherParameters>(ivParam, null);
    cipher.init(false, params);
    final decryptedBytes = cipher.process(encryptedBytes);
    return utf8.decode(decryptedBytes);
  }

  Map<String, dynamic> decodeJwtPayload(String token) {
    // Split the JWT into three parts (header, payload, signature)
    final parts = token.split('.');

    if (parts.length != 3) {
      throw const FormatException('Invalid JWT token');
    }

    // Decode the payload (second part) from Base64
    final payload = parts[1];
    final normalized = base64.normalize(payload);
    final decodedBytes = base64Url.decode(normalized);
    final decodedString = utf8.decode(decodedBytes);

    // Convert the decoded string into a Map (JSON object)
    return jsonDecode(decodedString);
  }
}

class TokenPayload {
  final int nbf;
  final int exp;
  final String iss;
  final String aud;
  final String clientId;
  final String sub;
  final int authTime;
  final String idp;
  final String name;
  final List<String> jlApplications;
  final String email;
  final List<String> scope;
  final List<String> amr;

  TokenPayload({
    required this.nbf,
    required this.exp,
    required this.iss,
    required this.aud,
    required this.clientId,
    required this.sub,
    required this.authTime,
    required this.idp,
    required this.name,
    required this.jlApplications,
    required this.email,
    required this.scope,
    required this.amr,
  });

  factory TokenPayload.fromJson(Map<String, dynamic> json) {
    return TokenPayload(
      nbf: json['nbf'] ?? 0,
      exp: json['exp'] ?? 0,
      iss: json['iss'] ?? '',
      aud: json['aud'] ?? '',
      clientId: json['client_id'] ?? '',
      sub: json['sub'] ?? '',
      authTime: json['auth_time'] ?? 0,
      idp: json['idp'] ?? '',
      name: json['name'] ?? '',
      jlApplications: List<String>.from(json['jl_applications'] ?? []),
      email: json['email'] ?? '',
      scope: List<String>.from(json['scope'] ?? []),
      amr: List<String>.from(json['amr'] ?? []),
    );
  }
}
