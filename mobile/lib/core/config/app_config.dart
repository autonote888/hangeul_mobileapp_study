class AppConfig {
  // Gunakan 10.0.2.2 untuk Android Emulator agar mengarah ke localhost host machine
  static const String keycloakBaseUrl = 'http://10.0.2.2:8080';
  static const String realm = 'flutter-realm';
  static const String clientId = 'flutter-mobile-app';
  static const String redirectUrl = 'my.flutter.app://oauth2redirect';
  static const String postLogoutRedirectUrl = 'my.flutter.app://oauth2redirect';

  static const String issuer = '$keycloakBaseUrl/realms/$realm';
  static const String discoveryUrl =
      '$issuer/.well-known/openid-configuration';

  // URL Backend Golang REST API
  static const String backendBaseUrl = 'http://10.0.2.2:8081/api/v1';

  static const List<String> scopes = [
    'openid',
    'profile',
    'email',
    'offline_access',
  ];
}

