import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/order_material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order_repository_provider.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);

  return OrderNotifier(orderRepository: orderRepository);
});

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository orderRepository;

  OrderNotifier({required this.orderRepository}) : super(OrderState()) {
    //loadOrder();
  }

  Future<void> loadOrder(int idOrder) async {
    try {
      if (state.idOrden == 0) {
        state = state.copyWith(
          isLoading: false,
          order: null,
        );
        return;
      }
      print("carga inciial");
      final order = await orderRepository.getOrderById(idOrder);
      // print(order.toJson());
      state = state.copyWith(
          isLoading: false, order: order, idOrden: order.idOrden);
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }

  addOrderMaterials(List<OrderMaterial> orderMaterialsSerial,
      List<OrderMaterial> orderMaterialsNotSerial) {
    state = state.copyWith(isLoading: true);

    List<OrderMaterial> orderMaterials = [];
    for (var orderMaterialSerial in orderMaterialsSerial) {
      orderMaterials.add(orderMaterialSerial);
    }
    for (var orderMaterialNotSerial in orderMaterialsNotSerial) {
      orderMaterials.add(orderMaterialNotSerial);
    }

    state = state.copyWith(isLoading: false, orderMaterials: orderMaterials);
  }
}

class OrderState {
  final int? idOrden;
  final Order? order;
  final bool isLoading;
  final bool isSaving;
  final List<OrderMaterial>? orderMaterials;

  OrderState({
    this.idOrden,
    this.order,
    this.isLoading = true,
    this.isSaving = false,
    this.orderMaterials = const [],
  });

  OrderState copyWith({
    int? idOrden,
    Order? order,
    bool? isLoading,
    bool? isSaving,
    List<OrderMaterial>? orderMaterials,
  }) =>
      OrderState(
        idOrden: idOrden ?? this.idOrden,
        order: order ?? this.order,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        orderMaterials: orderMaterials ?? this.orderMaterials,
      );
}
