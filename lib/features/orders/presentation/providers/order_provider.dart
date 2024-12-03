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

  void addOrderMaterialSeriado(Material material, int idMaterialCategory) {
    try {
      if (material.idMaterial == 0 || idMaterialCategory == 0) {
        return;
      }
      List<OrderMaterial> orderMaterials = state.orderMaterials!;

      if (orderMaterials
          .where((x) => x.idMaterial == material.idMaterial)
          .isNotEmpty) {
        return;
      }

      state = state.copyWith(isLoading: true);

      state = state.copyWith(isLoading: false, orderMaterials: [
        ...orderMaterials,
        OrderMaterial(
            idMaterial: material.idMaterial,
            material: material,
            idCategoria: idMaterialCategory,
            serie: "",
            cantidad: 1,
            esSeriado: true)
      ]);
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }

  void clearOrderMaterials(bool esSeriado) {
    state = state.copyWith(isLoading: true);
    List<OrderMaterial> orderMaterials = state.orderMaterials!;
    orderMaterials =
        orderMaterials.where((x) => x.esSeriado == !esSeriado).toList();

    state = state.copyWith(isLoading: false, orderMaterials: orderMaterials);
  }

  void removeOrderMaterialAnItem(int index) {
    List<OrderMaterial> orderMaterials = state.orderMaterials!;
    orderMaterials.removeAt(index);

    state = state.copyWith(orderMaterials: [...orderMaterials]);
  }

  void onChangedAnItem(int index, OrderMaterial material) {
    OrderMaterial orderMaterial = state.orderMaterials![index];
    orderMaterial.idCategoria = material.idCategoria;
    orderMaterial.idMaterial = material.idMaterial;
    orderMaterial.cantidad = 1;

    List<OrderMaterial> orderMaterials = state.orderMaterials!;
    orderMaterials[index] = orderMaterial;

    state = state.copyWith(orderMaterials: [...orderMaterials]);
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
