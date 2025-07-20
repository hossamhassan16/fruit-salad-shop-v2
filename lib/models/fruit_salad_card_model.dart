class FruitSaladCardModel {
  final String name, image;
  final int price;

  FruitSaladCardModel(
      {required this.name, required this.image, required this.price});
  factory FruitSaladCardModel.fromFirestore(Map<String, dynamic> data) {
    return FruitSaladCardModel(
        name: data["name"] ?? "",
        image: data["image"] ?? "",
        price: data['price'] is int
            ? data['price']
            : int.tryParse(data['price'].toString()) ?? 0);
  }
}
