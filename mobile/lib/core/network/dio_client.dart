import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/secure_storage_service.dart';
import '../../features/auth/services/auth_service.dart';

/// Interceptor menggunakan QueuedInterceptorsWrapper agar jika ada beberapa request
/// paralel yang terkena 401 secara bersamaan, request-request tersebut mengantri
/// dan tidak memicu race condition saat refresh token.
class AuthInterceptor extends QueuedInterceptorsWrapper {
  final SecureStorageService _storageService;
  final AuthService _authService;
  final Dio _retryDio;
  final void Function()? onSessionExpired;

  AuthInterceptor({
    required SecureStorageService storageService,
    required AuthService authService,
    required Dio retryDio,
    this.onSessionExpired,
  })  : _storageService = storageService,
        _authService = authService,
        _retryDio = retryDio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _storageService.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Hanya tangani HTTP 401 Unauthorized dan hindari infinite loop retry
    final isUnauthorized = err.response?.statusCode == 401;
    final hasRetried = err.requestOptions.extra['retried'] == true;

    if (isUnauthorized && !hasRetried) {
      // Cek apakah token di storage sudah diperbarui oleh request sebelumnya di antrian
      final currentStoredToken = await _storageService.getAccessToken();
      final requestAuthHeader =
          err.requestOptions.headers['Authorization'] as String?;
      final failedToken = requestAuthHeader?.replaceFirst('Bearer ', '');

      String? newAccessToken;
      if (currentStoredToken != null && currentStoredToken != failedToken) {
        // Token sudah di-refresh oleh antrian sebelumnya
        newAccessToken = currentStoredToken;
      } else {
        // Lakukan refresh token ke Keycloak via flutter_appauth
        newAccessToken = await _authService.refreshToken();
      }

      if (newAccessToken != null) {
        try {
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccessToken';
          opts.extra['retried'] = true;

          final cloneResponse = await _retryDio.fetch(opts);
          return handler.resolve(cloneResponse);
        } on DioException catch (retryErr) {
          return handler.next(retryErr);
        }
      } else {
        // Refresh token gagal / kadaluarsa -> paksa user login ulang
        onSessionExpired?.call();
      }
    }

    handler.next(err);
  }
}

class DioClient {
  late final Dio dio;

  DioClient({
    required SecureStorageService storageService,
    required AuthService authService,
    void Function()? onSessionExpired,
  }) {
    final baseOptions = BaseOptions(
      baseUrl: AppConfig.backendBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio = Dio(baseOptions);
    // Instance Dio terpisah untuk mengeksekusi ulang request yang gagal
    final retryDio = Dio(baseOptions);

    dio.interceptors.add(
      AuthInterceptor(
        storageService: storageService,
        authService: authService,
        retryDio: retryDio,
        onSessionExpired: onSessionExpired,
      ),
    );
  }
}

