import 'package:flutter/material.dart';
import 'package:fruite_salad_shop/utils/app_images.dart';
import 'package:fruite_salad_shop/utils/styles.dart';
import 'package:fruite_salad_shop/views/authentication_view.dart';
import 'package:fruite_salad_shop/widgets/custom_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              Assets.imagesWelcome,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 48,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Get The Freshest Fruit Salad Combo",
                style: Styles.style20medium,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "We deliver the best and freshest fruit salad in town. Order for a combo today!!!",
                style: Styles.style16regular.copyWith(height: 1.5),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            CustomButton(
              buttonText: "Let's Continue",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AuthenticationView();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
