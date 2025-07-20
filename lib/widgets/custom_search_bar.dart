import 'package:flutter/material.dart';
import 'package:fruite_salad_shop/utils/styles.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String)? onChanged;

  const CustomSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffF3F4F9),
      ),
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: "Search for fruit salad combos",
          hintStyle: Styles.style16regular.copyWith(fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
        ),
      ),
    );
  }
}
