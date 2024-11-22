import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order_repository_provider.dart';

final orderProvider = StateNotifierProvider.autoDispose
    .family<OrderNotifier, OrderState, String>((ref, productId) {
  final orderRepository = ref.watch(orderRepositoryProvider);

  return OrderNotifier(orderRepository: orderRepository, productId: productId);
});

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository orderRepository;

  OrderNotifier({
    required this.orderRepository,
    required String productId,
  }) : super(OrderState(id: productId)) {
    loadProduct();
  }

  Future<void> loadProduct() async {
    try {
      if (state.id == 'new') {
        state = state.copyWith(
          isLoading: false,
          order: null,
        );
        return;
      }

      final order = await orderRepository.getOrderById(state.order!.idOrden);

      state = state.copyWith(isLoading: false, order: order);
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }
}

class OrderState {
  final String id;
  final Order? order;
  final bool isLoading;
  final bool isSaving;

  OrderState({
    required this.id,
    this.order,
    this.isLoading = true,
    this.isSaving = false,
  });

  OrderState copyWith({
    String? id,
    Order? order,
    bool? isLoading,
    bool? isSaving,
  }) =>
      OrderState(
        id: id ?? this.id,
        order: order ?? this.order,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
