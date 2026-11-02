import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../../../core/config/app_config.dart';
import '../../../core/storage/secure_storage_service.dart';

class AuthTokens {
  final String accessToken;
  final String? refreshToken;
  final String? idToken;

  const AuthTokens({
    required this.accessToken,
    this.refreshToken,
    this.idToken,
  });
}

class AuthService {
  final FlutterAppAuth _appAuth;
  final SecureStorageService _storageService;

  AuthService({
    FlutterAppAuth? appAuth,
    required SecureStorageService storageService,
  })  : _appAuth = appAuth ?? const FlutterAppAuth(),
        _storageService = storageService;

  /// Membuka Chrome Custom Tabs / ASWebAuthenticationSession dengan Authorization Code + PKCE
  /// serta menukar authorization code menjadi accessToken, idToken, dan refreshToken.
  Future<AuthTokens> login({
    String? loginHint,
    Map<String, String>? additionalParameters,
  }) async {
    final result = await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        AppConfig.clientId,
        AppConfig.redirectUrl,
        discoveryUrl: AppConfig.discoveryUrl,
        scopes: AppConfig.scopes,
        loginHint: loginHint,
        additionalParameters: additionalParameters,
        // Gunakan true hanya saat development lokal menggunakan HTTP non-TLS
        allowInsecureConnections: true,
      ),
    );

    if (result.accessToken == null) {
      throw Exception('Login dibatalkan atau gagal mendapatkan Access Token.');
    }

    await _storageService.saveTokens(
      accessToken: result.accessToken!,
      refreshToken: result.refreshToken,
      idToken: result.idToken,
    );

    return AuthTokens(
      accessToken: result.accessToken!,
      refreshToken: result.refreshToken,
      idToken: result.idToken,
    );
  }

  /// Login langsung menggunakan form UI (Username & Password) ke endpoint Token Keycloak
  /// POST /realms/flutter-realm/protocol/openid-connect/token
  Future<AuthTokens> loginWithPassword({
    required String username,
    required String password,
  }) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: 1800),
        receiveTimeout: const Duration(milliseconds: 1800),
      ),
    );

    final response = await dio.post(
      '${AppConfig.issuer}/protocol/openid-connect/token',
      data: {
        'client_id': AppConfig.clientId,
        'grant_type': 'password',
        'username': username,
        'password': password,
        'scope': 'openid profile email',
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    final data = response.data as Map<String, dynamic>;
    final accessToken = data['access_token'] as String?;
    final refreshToken = data['refresh_token'] as String?;
    final idToken = data['id_token'] as String?;

    if (accessToken == null) {
      throw Exception('Gagal mendapatkan Access Token dari Keycloak.');
    }

    await _storageService.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      idToken: idToken,
    );

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      idToken: idToken,
    );
  }

  /// Login spesifik menggunakan Identity Provider Google di Keycloak (kc_idp_hint = google)
  Future<AuthTokens> loginWithGoogle() {
    return login(
      additionalParameters: {'kc_idp_hint': 'google'},
    );
  }

  /// Memperbarui sesi menggunakan refresh_token tanpa memaksa user login ulang
  Future<String?> refreshToken() async {
    final storedRefreshToken = await _storageService.getRefreshToken();
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      return null;
    }

    try {
      final TokenResponse response = await _appAuth.token(
        TokenRequest(
          AppConfig.clientId,
          AppConfig.redirectUrl,
          discoveryUrl: AppConfig.discoveryUrl,
          refreshToken: storedRefreshToken,
          scopes: AppConfig.scopes,
          allowInsecureConnections: true,
        ),
      );

      if (response.accessToken != null) {
        await _storageService.saveTokens(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken ?? storedRefreshToken,
          idToken: response.idToken,
        );
        return response.accessToken;
      }
      return null;
    } catch (_) {
      await _storageService.clearTokens();
      return null;
    }
  }

  /// Mengakhiri sesi OIDC di Keycloak via REST API (tanpa membuka browser eksternal)
  /// dan menghapus seluruh token dari Secure Storage agar kembali mulus ke halaman SignInPage.
  Future<void> logout() async {
    final refreshToken = await _storageService.getRefreshToken();
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(milliseconds: 1200),
            receiveTimeout: const Duration(milliseconds: 1200),
          ),
        );
        await dio.post(
          '${AppConfig.issuer}/protocol/openid-connect/logout',
          data: {
            'client_id': AppConfig.clientId,
            'refresh_token': refreshToken,
          },
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ),
        );
      }
    } catch (_) {
      // Abaikan jika jaringan offline, tetap bersihkan token lokal
    } finally {
      await _storageService.clearTokens();
    }
  }
}

