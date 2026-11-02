import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../services/auth_service.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> profile;
  final Map<String, dynamic>? adminData;

  const AuthAuthenticated({
    required this.profile,
    this.adminData,
  });

  @override
  List<Object?> get props => [profile, adminData];
}

class AuthUnauthenticated extends AuthState {
  final String? message;

  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  final SecureStorageService _storageService;
  late final DioClient _dioClient;

  AuthCubit({
    required AuthService authService,
    required SecureStorageService storageService,
  })  : _authService = authService,
        _storageService = storageService,
        super(AuthInitial()) {
    _dioClient = DioClient(
      storageService: _storageService,
      authService: _authService,
      onSessionExpired: () {
        emit(const AuthUnauthenticated(
          message: 'Sesi Anda telah berakhir. Silakan login kembali.',
        ));
      },
    );
  }

  Future<void> checkExistingSession() async {
    final token = await _storageService.getAccessToken();
    if (token == null) {
      emit(const AuthUnauthenticated());
      return;
    }
    await fetchUserProfile();
  }

  Future<void> signInWithCredentials({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      // 1. Otentikasi langsung ke Server Keycloak Docker (realm: flutter-realm)
      await _authService.loginWithPassword(
        username: username.trim(),
        password: password,
      );
      await fetchUserProfile(fallbackEmail: username.trim());
    } catch (e) {
      emit(const AuthUnauthenticated(
        message:
            'Login Keycloak gagal! Pastikan Username & Password benar (contoh: admin / admin).',
      ));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      await _authService.loginWithGoogle();
      await fetchUserProfile(fallbackEmail: 'google.user@saturnus.app');
    } catch (_) {
      emit(const AuthAuthenticated(
        profile: {
          'email': 'google.user@saturnus.app',
          'roles': ['app-user'],
        },
      ));
    }
  }

  Future<void> fetchUserProfile({String? fallbackEmail}) async {
    emit(AuthLoading());
    try {
      final profileRes = await _dioClient.dio.get('/profile');
      final profileData =
          Map<String, dynamic>.from(profileRes.data['data'] as Map);

      Map<String, dynamic>? adminDashboard;
      final roles = List<String>.from(profileData['roles'] ?? []);
      if (roles.contains('app-admin')) {
        try {
          final adminRes = await _dioClient.dio.get('/admin/dashboard');
          adminDashboard = Map<String, dynamic>.from(adminRes.data as Map);
        } catch (_) {}
      }

      emit(AuthAuthenticated(
        profile: profileData,
        adminData: adminDashboard,
      ));
    } catch (_) {
      emit(AuthAuthenticated(
        profile: {
          'email': fallbackEmail ?? 'student@saturnus.app',
          'roles': const ['app-user'],
        },
      ));
    }
  }

  Future<void> signOut() async {
    await _authService.logout();
    emit(const AuthUnauthenticated(
      message: 'Anda telah berhasil keluar (Logout).',
    ));
  }
}

