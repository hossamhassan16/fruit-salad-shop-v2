import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruite_salad_shop/models/fruit_salad_card_model.dart';
import 'package:fruite_salad_shop/widgets/fruit_salad_card.dart';

class NewComboTab extends StatelessWidget {
  const NewComboTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("fruit_salads")
          .where("category", isEqualTo: "new")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final data = snapshot.data!.docs
            .map((doc) => FruitSaladCardModel.fromFirestore(doc.data()))
            .toList();

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FruitSaladCard(fruitSaladCardModel: data[index]),
            );
          },
        );
      },
    );
  }
}
