import 'package:flutter/material.dart';
import 'package:fruite_salad_shop/utils/app_images.dart';
import 'package:fruite_salad_shop/utils/styles.dart';
import 'package:fruite_salad_shop/views/home_view.dart';
import 'package:fruite_salad_shop/widgets/custom_button.dart';
import 'package:fruite_salad_shop/widgets/custom_text_field.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                Assets.imagesAuth,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 48,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "What is your firstname?",
                  style: Styles.style20medium,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              CustomTextField(controller: _controller),
              SizedBox(
                height: 50,
              ),
              CustomButton(
                buttonText: "Start Ordering",
                onTap: () {
                  String name = _controller.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomeView(
                          name: name,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
