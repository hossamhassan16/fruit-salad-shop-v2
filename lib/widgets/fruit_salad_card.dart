import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruite_salad_shop/cubits/cart_cubit/cart_cubit_cubit.dart';
import 'package:fruite_salad_shop/cubits/favourite_cubit/favourite_cubit_cubit.dart';
import 'package:fruite_salad_shop/models/fruit_salad_card_model.dart';

class FruitSaladCard extends StatefulWidget {
  final FruitSaladCardModel fruitSaladCardModel;
  final VoidCallback? onAddToBasket;

  const FruitSaladCard({
    super.key,
    required this.fruitSaladCardModel,
    this.onAddToBasket,
  });

  @override
  State<FruitSaladCard> createState() => _FruitSaladCardState();
}

class _FruitSaladCardState extends State<FruitSaladCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAddPressed() {
    context.read<CartCubit>().addItem(widget.fruitSaladCardModel);
    _controller.forward(from: 0.0);
    widget.onAddToBasket?.call();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartCubit>().state;
    final cartItem = cartItems.firstWhere(
      (e) => e.item.name == widget.fruitSaladCardModel.name,
      orElse: () => CartItem(item: widget.fruitSaladCardModel, quantity: 0),
    );

    return BlocBuilder<FavoriteCubit, List<FruitSaladCardModel>>(
      builder: (context, favorites) {
        final isFavorite = context
            .read<FavoriteCubit>()
            .isFavorite(widget.fruitSaladCardModel);

        return Container(
          width: 152,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<FavoriteCubit>()
                        .toggleFavorite(widget.fruitSaladCardModel);
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: const Color(0xffFFA451),
                    size: 20,
                  ),
                ),
              ),
              Image.asset(
                widget.fruitSaladCardModel.image,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                widget.fruitSaladCardModel.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xff27214D),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${widget.fruitSaladCardModel.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff27214D),
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      if (cartItem.quantity > 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff27214D),
                            ),
                          ),
                        ),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: GestureDetector(
                          onTap: _onAddPressed,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffFFA451),
                            ),
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
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
