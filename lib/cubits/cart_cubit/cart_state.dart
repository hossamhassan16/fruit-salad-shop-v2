import 'package:equatable/equatable.dart';
import 'package:fruite_salad_shop/models/fruit_salad_card_model.dart';

class CartState extends Equatable {
  final List<FruitSaladCardModel> items;

  const CartState({this.items = const []});

  CartState copyWith({List<FruitSaladCardModel>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object> get props => [items];
}
