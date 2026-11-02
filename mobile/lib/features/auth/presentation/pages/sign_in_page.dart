import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth_cubit.dart';
import '../widgets/auth_background_scaffold.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController =
      TextEditingController(text: 'admin');
  final TextEditingController _passwordController =
      TextEditingController(text: 'admin');
  bool _obscurePassword = true;
  bool _isValidEmail = true;

  void _validateEmail(String value) {
    setState(() {
      _isValidEmail = value.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _openSignUpWith3DTransition(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 240),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignUpPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.08, 0.03),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AuthBackgroundScaffold(
          subtitle: 'WELCOME BACK',
          title: 'HELLO SIGN IN',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Isian EMAIL ADDRESS dengan Shape 3D & Smooth Transition saat digerakkan
              Interactive3DInputField(
                label: 'EMAIL ADDRESS',
                hintText: 'Masukkan Username / Email (admin)',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
                onChanged: _validateEmail,
                suffixIcon: _isValidEmail
                    ? const Icon(
                        Icons.verified_rounded,
                        color: Color(0xFF10B981),
                        size: 20,
                      )
                    : null,
              ),

              const SizedBox(height: 22),

              // 2. Isian PASSWORD dengan Shape 3D & Smooth Transition saat digerakkan
              Interactive3DInputField(
                label: 'PASSWORD',
                hintText: 'Masukkan Password (admin)',
                controller: _passwordController,
                obscureText: _obscurePassword,
                letterSpacing: _obscurePassword ? 2.2 : 0.4,
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppTheme.labelGrey,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Forgot Password?
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 1500),
                        content:
                            Text('Gunakan Username: admin & Password: admin'),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // SIGN IN Button -> Respon Instan (<16ms)
              PrimaryAuthButton(
                label: 'SIGN IN',
                isLoading: isLoading,
                onPressed: () {
                  context.read<AuthCubit>().signInWithCredentials(
                        username: _emailController.text.trim(),
                        password: _passwordController.text,
                      );
                },
              ),

              const SizedBox(height: 24),

              // Divider "or continue with"
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: AppTheme.inputBorderGrey),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or continue with',
                      style: TextStyle(
                        color: AppTheme.labelGrey.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: AppTheme.inputBorderGrey),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Sign in with Google Button dengan efek 3D Tilt Card
              Interactive3DTiltCard(
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFE2E8F0),
                        blurRadius: 0,
                        offset: Offset(0, 3.5),
                      ),
                    ],
                  ),
                  child: OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () => context.read<AuthCubit>().signInWithGoogle(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GoogleLogoIcon(size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: Color(0xFF334155),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Don't have an account? Sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?  ",
                    style: TextStyle(
                      color: AppTheme.labelGrey,
                      fontSize: 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openSignUpWith3DTransition(context),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: AppTheme.orangeAction,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Widget Vektor Resmi Logo "G" Google 4-Warna (Blue, Red, Yellow, Green)
class GoogleLogoIcon extends StatelessWidget {
  final double size;

  const GoogleLogoIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width / 24.0;
    canvas.scale(s, s);

    // 1. Blue (Kanan + Palang Horizontal)
    final bluePath = Path()
      ..moveTo(22.56, 12.25)
      ..cubicTo(22.56, 11.47, 22.49, 10.72, 22.36, 10.0)
      ..lineTo(12.0, 10.0)
      ..lineTo(12.0, 14.26)
      ..lineTo(17.92, 14.26)
      ..cubicTo(17.66, 15.63, 16.88, 16.79, 15.71, 17.57)
      ..lineTo(15.71, 20.34)
      ..lineTo(19.28, 20.34)
      ..cubicTo(21.36, 18.42, 22.56, 15.6, 22.56, 12.25)
      ..close();
    canvas.drawPath(bluePath, Paint()..color = const Color(0xFF4285F4));

    // 2. Green (Lengkungan Bawah)
    final greenPath = Path()
      ..moveTo(12.0, 23.0)
      ..cubicTo(14.97, 23.0, 17.46, 22.02, 19.28, 20.34)
      ..lineTo(15.71, 17.57)
      ..cubicTo(14.73, 18.23, 13.48, 18.63, 12.0, 18.63)
      ..cubicTo(9.14, 18.63, 6.71, 16.7, 5.84, 14.1)
      ..lineTo(2.18, 14.1)
      ..lineTo(2.18, 16.94)
      ..cubicTo(3.99, 20.53, 7.7, 23.0, 12.0, 23.0)
      ..close();
    canvas.drawPath(greenPath, Paint()..color = const Color(0xFF34A853));

    // 3. Yellow (Lengkungan Kiri)
    final yellowPath = Path()
      ..moveTo(5.84, 14.09)
      ..cubicTo(5.62, 13.43, 5.49, 12.73, 5.49, 12.0)
      ..cubicTo(5.49, 11.27, 5.62, 10.57, 5.84, 9.91)
      ..lineTo(5.84, 7.07)
      ..lineTo(2.18, 7.07)
      ..cubicTo(1.43, 8.55, 1.0, 10.22, 1.0, 12.0)
      ..cubicTo(1.0, 13.78, 1.43, 15.45, 2.18, 16.93)
      ..lineTo(5.03, 14.71)
      ..lineTo(5.84, 14.09)
      ..close();
    canvas.drawPath(yellowPath, Paint()..color = const Color(0xFFFBBC05));

    // 4. Red (Lengkungan Atas)
    final redPath = Path()
      ..moveTo(12.0, 5.38)
      ..cubicTo(13.62, 5.38, 15.06, 5.94, 16.21, 7.02)
      ..lineTo(19.36, 3.87)
      ..cubicTo(17.45, 2.09, 14.97, 1.0, 12.0, 1.0)
      ..cubicTo(7.7, 1.0, 3.99, 3.47, 2.18, 7.07)
      ..lineTo(5.84, 9.91)
      ..cubicTo(6.71, 7.31, 9.14, 5.38, 12.0, 5.38)
      ..close();
    canvas.drawPath(redPath, Paint()..color = const Color(0xFFEA4335));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
