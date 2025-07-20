import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fruite_salad_shop/models/fruit_salad_card_model.dart';
import 'package:fruite_salad_shop/widgets/fruit_salad_card.dart';

class RecommendedListView extends StatelessWidget {
  final String searchQuery;

  const RecommendedListView({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("fruit_salads").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No fruit salads found."));
        }

        final allData = snapshot.data!.docs
            .map((doc) => FruitSaladCardModel.fromFirestore(doc.data()))
            .toList();

        final filteredData = allData.where((item) {
          return item.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        if (filteredData.isEmpty) {
          return const Center(child: Text("No results found."));
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FruitSaladCard(
                  fruitSaladCardModel: filteredData[index],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
