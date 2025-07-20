import 'package:flutter/material.dart';
import 'package:fruite_salad_shop/utils/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonText,
    this.onTap,
  });
  final String buttonText;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: 330,
          height: 56,
          decoration: BoxDecoration(
            color: Color(0xffFFA451),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Text(
            buttonText,
            style: Styles.style20medium.copyWith(color: Colors.white),
          )),
        ),
      ),
    );
  }
}
