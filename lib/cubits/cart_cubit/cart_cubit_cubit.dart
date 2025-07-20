import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruite_salad_shop/models/fruit_salad_card_model.dart';

class CartItem {
  final FruitSaladCardModel item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});
}

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]);

  void addItem(FruitSaladCardModel item) {
    final index = state.indexWhere((e) => e.item.name == item.name);
    if (index != -1) {
      state[index].quantity++;
      emit(List.from(state));
    } else {
      emit([...state, CartItem(item: item)]);
    }
  }

  void removeItem(FruitSaladCardModel item) {
    final updated = state.where((e) => e.item.name != item.name).toList();
    emit(updated);
  }

  void decrementItem(FruitSaladCardModel item) {
    final index = state.indexWhere((e) => e.item.name == item.name);
    if (index != -1) {
      if (state[index].quantity > 1) {
        state[index].quantity--;
      } else {
        state.removeAt(index);
      }
      emit(List.from(state));
    }
  }

  void clearCart() {
    emit([]);
  }

  double get totalPrice =>
      state.fold(0, (sum, e) => sum + (e.item.price * e.quantity));
}
