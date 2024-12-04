import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/order_material.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/material_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order_repository_provider.dart';

final orderMaterialsSerialProvider =
    StateNotifierProvider<OrderMaterialsSerialNotifier, OrderMaterialsState>(
        (ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);

  return OrderMaterialsSerialNotifier(orderRepository: orderRepository);
});

class OrderMaterialsSerialNotifier extends StateNotifier<OrderMaterialsState> {
  final OrderRepository orderRepository;

  OrderMaterialsSerialNotifier({required this.orderRepository})
      : super(OrderMaterialsState()) {
    //loadOrder();
  }

  void addOrderMaterialSeriado(Material material, int idMaterialCategory) {
    try {
      if (material.idMaterial == 0 || idMaterialCategory == 0) {
        return;
      }
      List<OrderMaterial> orderMaterials = state.orderMaterialsSerial!;

      if (orderMaterials
          .where((x) => x.idMaterial == material.idMaterial)
          .isNotEmpty) {
        return;
      }

      state = state.copyWith(isLoading: true);

      state = state.copyWith(isLoading: false, orderMaterialsSerial: [
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
    List<OrderMaterial> orderMaterials = state.orderMaterialsSerial!;
    orderMaterials =
        orderMaterials.where((x) => x.esSeriado == !esSeriado).toList();

    state =
        state.copyWith(isLoading: false, orderMaterialsSerial: orderMaterials);
  }

  void removeOrderMaterialAnItem(int index) {
    List<OrderMaterial> orderMaterials = state.orderMaterialsSerial!;
    orderMaterials.removeAt(index);

    state = state.copyWith(orderMaterialsSerial: [...orderMaterials]);
  }

  updateOrderMaterialAnItem(int index, String serie) {
    OrderMaterial orderMaterial = state.orderMaterialsSerial![index];
    orderMaterial.serie = serie;

    List<OrderMaterial> orderMaterials = state.orderMaterialsSerial!;
    orderMaterials[index] = orderMaterial;

    state = state.copyWith(orderMaterialsSerial: [...orderMaterials]);
  }
}

final orderMaterialsNotSerialProvider =
    StateNotifierProvider<OrderMaterialsNotSerialNotifier, OrderMaterialsState>(
        (ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  final materialRepository = ref.watch(materialRepositoryProvider);

  return OrderMaterialsNotSerialNotifier(
    orderRepository: orderRepository,
    materialRepository: materialRepository,
  );
});

class OrderMaterialsNotSerialNotifier
    extends StateNotifier<OrderMaterialsState> {
  final OrderRepository orderRepository;
  final MaterialRepository materialRepository;

  OrderMaterialsNotSerialNotifier(
      {required this.orderRepository, required this.materialRepository})
      : super(OrderMaterialsState()) {
    //loadOrder();
  }

  Future<void> getOrderMaterialsGroup() async {
    try {
      state = state.copyWith(isLoading: false);

      List<MaterialCategory> materialsCategorys =
          await materialRepository.getListGroupByFilters(esSeriado: false);

      List<OrderMaterialGroup> orderMaterialsGroup = [];
      for (var materialsCategory in materialsCategorys) {
        OrderMaterialGroup orderMaterialGroup =
            OrderMaterialGroup(idCategoria: materialsCategory.idCategoria);
        orderMaterialGroup.category = MaterialCategory(
          idCategoria: materialsCategory.idCategoria,
          nombreCategoria: materialsCategory.nombreCategoria,
        );
        orderMaterialGroup.materials = [];
        for (var material in materialsCategory.materiales!) {
          orderMaterialGroup.materials!.add(OrderMaterial(
            idMaterial: material.idMaterial,
            material: material,
            idCategoria: materialsCategory.idCategoria,
            cantidad: 0,
          ));
        }

        orderMaterialsGroup.add(orderMaterialGroup);
      }

      state = state.copyWith(
        isLoading: false,
        orderMaterialsGroupNotSerial: orderMaterialsGroup,
      );
    } catch (e) {
      // 404 product not found
      print(e);
    }
  }

  updateOrderMaterialAnItem(int idCategoria, int indexMaterial, int cantidad) {
    OrderMaterialGroup orderMaterialGroup = state.orderMaterialsGroupNotSerial!
        .firstWhere((x) => x.idCategoria == idCategoria);
    orderMaterialGroup.materials![indexMaterial].cantidad = cantidad;

    List<OrderMaterialGroup> orderMaterialsGroup =
        state.orderMaterialsGroupNotSerial!;
    orderMaterialsGroup[orderMaterialsGroup.indexWhere(
        (element) => element.idCategoria == idCategoria)] = orderMaterialGroup;

    state = state.copyWith(orderMaterialsGroupNotSerial: orderMaterialsGroup);
  }
}

class OrderMaterialsState {
  final int? idOrden;
  final bool isLoading;
  final bool isSaving;
  final List<OrderMaterial>? orderMaterialsSerial;
  final List<OrderMaterial>? orderMaterialsNotSerial;
  final List<OrderMaterialGroup>? orderMaterialsGroupNotSerial;

  OrderMaterialsState({
    this.idOrden,
    this.isLoading = true,
    this.isSaving = false,
    this.orderMaterialsSerial = const [],
    this.orderMaterialsNotSerial = const [],
    this.orderMaterialsGroupNotSerial = const [],
  });

  OrderMaterialsState copyWith({
    int? idOrden,
    bool? isLoading,
    bool? isSaving,
    List<OrderMaterial>? orderMaterialsSerial,
    List<OrderMaterial>? orderMaterialsNotSerial,
    List<OrderMaterialGroup>? orderMaterialsGroupNotSerial,
  }) =>
      OrderMaterialsState(
        idOrden: idOrden ?? this.idOrden,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        orderMaterialsSerial: orderMaterialsSerial ?? this.orderMaterialsSerial,
        orderMaterialsNotSerial:
            orderMaterialsNotSerial ?? this.orderMaterialsNotSerial,
        orderMaterialsGroupNotSerial:
            orderMaterialsGroupNotSerial ?? this.orderMaterialsGroupNotSerial,
      );
}
