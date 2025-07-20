import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruite_salad_shop/cubits/auth_cubit/auth_cubit.dart';
import 'package:fruite_salad_shop/views/reset_password_page.dart';
import 'package:fruite_salad_shop/views/signup_page,dart';
import 'package:fruite_salad_shop/views/home_view.dart';
import 'package:fruite_salad_shop/utils/styles.dart';
import 'package:fruite_salad_shop/utils/app_images.dart';
import 'package:fruite_salad_shop/widgets/custom_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeView(name: emailCtrl.text.split('@')[0]),
              ),
            );
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  Assets.imagesWelcome,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Welcome Back",
                    style: Styles.style20medium,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Login to continue enjoying the freshest fruit salad combos!",
                    style: Styles.style16regular.copyWith(height: 1.5),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailCtrl,
                          decoration: const InputDecoration(labelText: "Email"),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter email';
                            }
                            if (!val.contains('@')) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passCtrl,
                          obscureText: true,
                          decoration:
                              const InputDecoration(labelText: "Password"),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter password';
                            }
                            if (val.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                state is AuthLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: CustomButton(
                          buttonText: "Login",
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().login(
                                    email: emailCtrl.text.trim(),
                                    password: passCtrl.text.trim(),
                                  );
                            }
                          },
                        ),
                      ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResetPasswordPage(),
                      ),
                    );
                  },
                  child: const Text("Forgot Password?"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SignUpPage(),
                      ),
                    );
                  },
                  child: const Text("Create an Account"),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
