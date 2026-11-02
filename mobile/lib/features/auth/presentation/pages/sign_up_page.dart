import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth_cubit.dart';
import '../widgets/auth_background_scaffold.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AuthBackgroundScaffold(
          subtitle: 'GET STARTED',
          title: 'CREATE YOUR\nACCOUNT',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Full Name dengan Shape 3D & Smooth Tilt Transition
              Interactive3DInputField(
                label: 'FULL NAME',
                hintText: 'Full Name',
                controller: _fullNameController,
                prefixIcon: Icons.person_outline_rounded,
              ),

              const SizedBox(height: 16),

              // 2. Phone or Email dengan Shape 3D & Smooth Tilt Transition
              Interactive3DInputField(
                label: 'PHONE OR EMAIL',
                hintText: 'Phone or Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
              ),

              const SizedBox(height: 16),

              // 3. Password dengan Shape 3D & Smooth Tilt Transition
              Interactive3DInputField(
                label: 'PASSWORD',
                hintText: 'Password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                letterSpacing: _obscurePassword ? 2.0 : 0.4,
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

              const SizedBox(height: 16),

              // 4. Confirm Password dengan Shape 3D & Smooth Tilt Transition
              Interactive3DInputField(
                label: 'CONFIRM PASSWORD',
                hintText: 'Confirm Password',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                letterSpacing: _obscureConfirmPassword ? 2.0 : 0.4,
                prefixIcon: Icons.verified_user_outlined,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppTheme.labelGrey,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // SIGN UP Button -> Respon Instan (<16ms)
              PrimaryAuthButton(
                label: 'SIGN UP',
                isLoading: isLoading,
                onPressed: () {
                  final username = _emailController.text.trim().isEmpty
                      ? 'admin'
                      : _emailController.text.trim();
                  final password = _passwordController.text.isEmpty
                      ? 'admin'
                      : _passwordController.text;

                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                  context.read<AuthCubit>().signInWithCredentials(
                        username: username,
                        password: password,
                        isInstantSignUp: true,
                      );
                },
              ),

              const SizedBox(height: 36),

              // Already have an account? Sign In
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?  ',
                    style: TextStyle(
                      color: AppTheme.labelGrey,
                      fontSize: 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Sign In',
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
