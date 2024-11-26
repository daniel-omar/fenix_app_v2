import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order_repository_provider.dart';

final orderProvider = StateNotifierProvider.autoDispose
    .family<OrderNotifier, OrderState, int>((ref, idOrden) {
  final orderRepository = ref.watch(orderRepositoryProvider);

  return OrderNotifier(orderRepository: orderRepository, idOrden: idOrden);
});

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository orderRepository;

  OrderNotifier({
    required this.orderRepository,
    required int idOrden,
  }) : super(OrderState(idOrden: idOrden)) {
    loadProduct();
  }

  Future<void> loadProduct() async {
    try {
      if (state.idOrden == 0) {
        state = state.copyWith(
          isLoading: false,
          order: null,
        );
        return;
      }

      final order = await orderRepository.getOrderById(state.idOrden);
      // print(order.toJson());
      state = state.copyWith(isLoading: false, order: order);
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }
}

class OrderState {
  final int idOrden;
  final Order? order;
  final bool isLoading;
  final bool isSaving;

  OrderState({
    required this.idOrden,
    this.order,
    this.isLoading = true,
    this.isSaving = false,
  });

  OrderState copyWith({
    int? idOrden,
    Order? order,
    bool? isLoading,
    bool? isSaving,
  }) =>
      OrderState(
        idOrden: idOrden ?? this.idOrden,
        order: order ?? this.order,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
