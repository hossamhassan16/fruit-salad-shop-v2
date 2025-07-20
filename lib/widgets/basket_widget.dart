import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruite_salad_shop/cubits/cart_cubit/cart_cubit_cubit.dart';
import 'package:fruite_salad_shop/utils/app_images.dart';
import 'package:fruite_salad_shop/utils/styles.dart';

class BasketWidget extends StatelessWidget {
  const BasketWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SvgPicture.asset(Assets.imagesBasket),
            Positioned(
              right: 0,
              top: 0,
              child: BlocBuilder<CartCubit, List<CartItem>>(
                builder: (context, cartItems) {
                  final itemCount = cartItems.fold<int>(
                      0, (sum, item) => sum + item.quantity);
                  return itemCount == 0
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$itemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
        Text(
          "My Basket",
          style: Styles.style16regular.copyWith(
            fontSize: 10,
            color: const Color(0xff27214D),
          ),
        )
      ],
    );
  }
}
