import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import '../flutter_sodium.dart';

/// The original ChaCha20-Poly1305 construction
class ChaCha20Poly1305 {
  /// Generates a random key for use with the ChaCha20-Poly1305 construction.
  static Future<Uint8List> generateKey() =>
      Sodium.cryptoAeadChacha20poly1305Keygen();

  /// Generates a random nonce for use with the ChaCha20-Poly1305 construction.
  static Future<Uint8List> generateNonce() =>
      RandomBytes.buffer(crypto_aead_chacha20poly1305_NPUBBYTES);

  /// Encrypts a string message with optional additional data, a key and a nonce.
  static Future<Uint8List> encrypt(String value, String additionalData,
          Uint8List nonce, Uint8List key) =>
      Sodium.cryptoAeadChacha20poly1305Encrypt(
          utf8.encode(value),
          additionalData == null ? null : utf8.encode(additionalData),
          null,
          nonce,
          key);

  /// Encrypts a message with optional additional data, a key and a nonce.
  static Future<Uint8List> encryptBytes(Uint8List value,
          Uint8List additionalData, Uint8List nonce, Uint8List key) =>
      Sodium.cryptoAeadChacha20poly1305Encrypt(
          value, additionalData, null, nonce, key);

  /// Verifies and decrypts a cipher text produced by encrypt.
  static Future<String> decrypt(Uint8List cipherText, String additionalData,
      Uint8List nonce, Uint8List key) async {
    final message = await Sodium.cryptoAeadChacha20poly1305Decrypt(
        null,
        cipherText,
        additionalData == null ? null : utf8.encode(additionalData),
        nonce,
        key);
    return utf8.decode(message);
  }

  /// Verifies and decrypts a cipher text produced by encrypt.
  static Future<Uint8List> decryptBytes(Uint8List cipherText,
          Uint8List additionalData, Uint8List nonce, Uint8List key) =>
      Sodium.cryptoAeadChacha20poly1305Decrypt(
          null, cipherText, additionalData, nonce, key);

  /// Encrypts a string message with optional additional data, a key and a nonce. Returns a detached cipher text and mac.
  static Future<DetachedCipher> encryptDetached(String value,
      String additionalData, Uint8List nonce, Uint8List key) async {
    var map = await Sodium.cryptoAeadChacha20poly1305EncryptDetached(
        utf8.encode(value),
        additionalData == null ? null : utf8.encode(additionalData),
        null,
        nonce,
        key);
    return DetachedCipher.fromMap(map);
  }

  /// Encrypts a message with optional additional data, a key and a nonce. Returns a detached cipher text and mac.
  static Future<DetachedCipher> encryptBytesDetached(Uint8List value,
      Uint8List additionalData, Uint8List nonce, Uint8List key) async {
    var map = await Sodium.cryptoAeadChacha20poly1305EncryptDetached(
        value, additionalData, null, nonce, key);
    return DetachedCipher.fromMap(map);
  }

  /// Verifies and decrypts a cipher text and mac produced by encrypt detached.
  static Future<String> decryptDetached(DetachedCipher cipher,
      String additionalData, Uint8List nonce, Uint8List key) async {
    final message = await Sodium.cryptoAeadChacha20poly1305DecryptDetached(
        null,
        cipher.cipher,
        cipher.mac,
        additionalData == null ? null : utf8.encode(additionalData),
        nonce,
        key);
    return utf8.decode(message);
  }

  /// Verifies and decrypts a cipher text and mac produced by encrypt detached.
  static Future<Uint8List> decryptBytesDetached(DetachedCipher cipher,
          Uint8List additionalData, Uint8List nonce, Uint8List key) =>
      Sodium.cryptoAeadChacha20poly1305DecryptDetached(
          null, cipher.cipher, cipher.mac, additionalData, nonce, key);
}
