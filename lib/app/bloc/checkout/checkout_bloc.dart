// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/product_detail_response_model.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutLoaded(items: [])) {
    on<AddToCartEvent>((event, emit) {
      final currentState = state as CheckoutLoaded;
      emit(CheckoutLoading());
      emit(CheckoutLoaded(items: [...currentState.items, event.data]));
    });

    on<RemoveFromCartEvent>((event, emit) {
      final currentState = state as CheckoutLoaded;
      currentState.items.remove(event.data);
      emit(CheckoutLoading());
      emit(CheckoutLoaded(items: currentState.items));
    });

    on<RemoveAllByIDFromCart>(
      (event, emit) {
        final currentState = state as CheckoutLoaded;
        currentState.items.removeWhere((element) => element.id == event.id);
        emit(CheckoutLoading());
        emit(CheckoutLoaded(items: currentState.items));
      },
    );

    on<RemoveAllFromCartEvent>((event, emit) {
      final currentState = state as CheckoutLoaded;
      currentState.items.clear();
      emit(CheckoutLoading());
      emit(CheckoutLoaded(items: currentState.items));
    });
  }
}
