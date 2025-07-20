import 'package:bloc/bloc.dart';
import 'package:fruite_salad_shop/models/fruit_salad_card_model.dart';
import 'package:meta/meta.dart';

part 'favourite_cubit_state.dart';

class FavoriteCubit extends Cubit<List<FruitSaladCardModel>> {
  FavoriteCubit() : super([]);

  void toggleFavorite(FruitSaladCardModel item) {
    if (state.contains(item)) {
      emit(List.from(state)..remove(item));
    } else {
      emit(List.from(state)..add(item));
    }
  }

  bool isFavorite(FruitSaladCardModel item) {
    return state.contains(item);
  }
}
