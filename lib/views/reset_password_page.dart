import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruite_salad_shop/cubits/auth_cubit/auth_cubit.dart';
import 'package:fruite_salad_shop/utils/app_images.dart';
import 'package:fruite_salad_shop/utils/styles.dart';
import 'package:fruite_salad_shop/widgets/custom_button.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
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
                    "Reset Password",
                    style: Styles.style20medium,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Enter your email to reset your password.",
                    style: Styles.style16regular.copyWith(height: 1.5),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                ),
                const SizedBox(height: 32),
                state is AuthLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: CustomButton(
                          buttonText: "Send Reset Link",
                          onTap: () {
                            context.read<AuthCubit>().resetPassword(
                                  email: emailCtrl.text.trim(),
                                );
                          },
                        ),
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
