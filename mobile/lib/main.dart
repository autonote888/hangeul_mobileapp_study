import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/storage/secure_storage_service.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/services/auth_service.dart';
import 'features/hangeul/presentation/pages/hangeul_home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = SecureStorageService();
  final authService = AuthService(storageService: storageService);

  runApp(
    BlocProvider(
      create: (_) => AuthCubit(
        authService: authService,
        storageService: storageService,
      ),
      child: const KeycloakFlutterApp(),
    ),
  );
}

class KeycloakFlutterApp extends StatelessWidget {
  const KeycloakFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saturnus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated && state.message != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 1600),
                  behavior: SnackBarBehavior.floating,
                  content: Text(state.message!),
                ),
              );
          }
        },
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.96, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
            child: state is AuthAuthenticated
                ? HangeulHomePage(
                    key: const ValueKey('hangeul_home_page'),
                    userEmail: (state.profile['email'] as String?) ??
                        'student@saturnus.app',
                  )
                : const SignInPage(
                    key: ValueKey('sign_in_page'),
                  ),
          );
        },
      ),
    );
  }
}
