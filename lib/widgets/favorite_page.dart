import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruite_salad_shop/cubits/favourite_cubit/favourite_cubit_cubit.dart';
import 'package:fruite_salad_shop/models/fruit_salad_card_model.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Favorites",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: BlocBuilder<FavoriteCubit, List<FruitSaladCardModel>>(
        builder: (context, favorites) {
          if (favorites.isEmpty) {
            return const Center(child: Text("No favorites yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final item = favorites[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Image.asset(item.image, height: 100),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Icon(Icons.favorite, color: Colors.orange),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
