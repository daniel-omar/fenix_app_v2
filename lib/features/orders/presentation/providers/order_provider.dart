import 'dart:convert';

import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/order_customer.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/order_material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'order_repository_provider.dart';

final orderProvider =
    StateNotifierProvider.family<OrderNotifier, OrderState, int?>(
        (ref, idOrder) {
  final orderRepository = ref.watch(orderRepositoryProvider);

  return OrderNotifier(orderRepository: orderRepository, idOrder: idOrder ?? 0);
});

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository orderRepository;
  final int idOrder;

  OrderNotifier({required this.orderRepository, required this.idOrder})
      : super(OrderState(isLoading: true)) {
    loadOrder(idOrder);
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
      //print("carga inciial");
      final order = await orderRepository.getOrderById(idOrder!);
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

  updateCustomerOrder(CustomerOrder customerOrder) {
    state = state.copyWith(customerOrder: customerOrder);
  }

  updateOrder(Order order) {
    state = state.copyWith(order: order);
  }

  updateTechnicalObservation(String value) {
    state = state.copyWith(technicalObservation: value);
  }

  removeEvidences() {
    state = state.copyWith(evidences: []);
  }

  addEvidence(XFile file) {
    List<XFile>? evidencesList = state.evidences;

    evidencesList = evidencesList ?? [];
    evidencesList.add(file);

    state = state.copyWith(evidences: evidencesList);
  }

  Future<void> liquidateOrder() async {
    try {
      state = state.copyWith(isLoading: true, isSaving: false);

      final orderLiquidated = {
        'orden': state.order!.toJson(),
        'cliente_orden': state.customerOrder!.toJson(),
        'materiales_orden':
            state.orderMaterials!.map((e) => e.toJson()).toList(),
        'observacion_tecnico': state.technicalObservation,
      };

      final order = await orderRepository.liquidateOrder(
          orderLiquidated, state.evidences!);
      // print(order.toJson());
      state = state.copyWith(isLoading: false, isSaving: true);
    } catch (e) {
      // 404 product not found
      state = state.copyWith(isLoading: false, isSaving: false);

      print(e);
    }
  }

  clearData() {
    state = state.copyWith(
        isLoading: false,
        isSaving: false,
        order: null,
        orderMaterials: [],
        customerOrder: null,
        technicalObservation: '',
        evidences: []);
  }
}

class OrderState {
  final int? idOrden;
  final Order? order;
  final bool isLoading;
  final bool isSaving;
  final List<OrderMaterial>? orderMaterials;
  final CustomerOrder? customerOrder;
  final String? technicalObservation;
  final List<XFile>? evidences;

  OrderState({
    this.idOrden,
    this.order,
    this.isLoading = true,
    this.isSaving = false,
    this.orderMaterials = const [],
    this.customerOrder,
    this.technicalObservation,
    this.evidences,
  });

  OrderState copyWith({
    int? idOrden,
    Order? order,
    bool? isLoading,
    bool? isSaving,
    List<OrderMaterial>? orderMaterials,
    CustomerOrder? customerOrder,
    String? technicalObservation,
    List<XFile>? evidences,
  }) =>
      OrderState(
        idOrden: idOrden ?? this.idOrden,
        order: order ?? this.order,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        orderMaterials: orderMaterials ?? this.orderMaterials,
        customerOrder: customerOrder ?? this.customerOrder,
        technicalObservation: technicalObservation ?? this.technicalObservation,
        evidences: evidences ?? this.evidences,
      );
}
