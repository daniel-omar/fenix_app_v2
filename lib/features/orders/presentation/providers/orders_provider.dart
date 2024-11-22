import 'package:fenix_app_v2/config/router/app_router_notifier.dart';
import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order_repository_provider.dart';

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  final ordersRepository = ref.watch(orderRepositoryProvider);

  return OrdersNotifier(ordersRepository: ordersRepository);
});

class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrderRepository ordersRepository;

  OrdersNotifier({
    required this.ordersRepository,
  }) : super(OrdersState()) ;
  
  Future getOrdersByTechnical(int idTecnico, {int? idEstadoOrden}) async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await ordersRepository.getOrdersByTechnical(idTecnico,
        limit: state.limit,
        offset: state.offset,
        idsEstadoOrden: [idEstadoOrden!]);

    if (products.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 10,
        orders: [...state.orders, ...products]);
  }
}

class OrdersState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Order> orders;

  OrdersState(
      {this.isLastPage = false,
      this.limit = 10,
      this.offset = 0,
      this.isLoading = false,
      this.orders = const []});

  OrdersState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Order>? orders,
  }) =>
      OrdersState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        orders: orders ?? this.orders,
      );
}
