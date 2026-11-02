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
              // Full Name
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  hintText: 'Full Name',
                  hintStyle: TextStyle(
                    color: AppTheme.labelGrey,
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppTheme.labelGrey,
                    size: 20,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.inputBorderGrey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primaryButtonNavy),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Phone or Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Phone or Email',
                  hintStyle: TextStyle(
                    color: AppTheme.labelGrey,
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: AppTheme.labelGrey,
                    size: 20,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.inputBorderGrey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primaryButtonNavy),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Password
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    color: AppTheme.labelGrey,
                    fontSize: 15,
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppTheme.labelGrey,
                    size: 20,
                  ),
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
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.inputBorderGrey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primaryButtonNavy),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Confirm Password
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  hintStyle: const TextStyle(
                    color: AppTheme.labelGrey,
                    fontSize: 15,
                  ),
                  prefixIcon: const Icon(
                    Icons.verified_user_outlined,
                    color: AppTheme.labelGrey,
                    size: 20,
                  ),
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
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.inputBorderGrey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primaryButtonNavy),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // SIGN UP Button -> Mengarahkan ke alur login dengan akun yang diisi
              PrimaryAuthButton(
                label: 'SIGN UP',
                isLoading: isLoading,
                onPressed: () {
                  context.read<AuthCubit>().signInWithCredentials(
                        username: _emailController.text.trim().isEmpty
                            ? 'admin'
                            : _emailController.text.trim(),
                        password: _passwordController.text.isEmpty
                            ? 'admin'
                            : _passwordController.text,
                      );
                },
              ),

              const SizedBox(height: 64),

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
                        fontWeight: FontWeight.w700,
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

