import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/order_customer.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/customer_order_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final customerOrderProvider = StateNotifierProvider.autoDispose
    .family<CustomerOrderNotifier, CustomerOrderState, int>((ref, idOrder) {
  final customerOrderRepository = ref.watch(customerOrderRepositoryProvider);

  return CustomerOrderNotifier(
    customerOrderRepository: customerOrderRepository,
    idOrder: idOrder,
  );
});

class CustomerOrderNotifier extends StateNotifier<CustomerOrderState> {
  final CustomerOrderRepository customerOrderRepository;

  CustomerOrderNotifier({
    required this.customerOrderRepository,
    required int? idOrder,
  }) : super(CustomerOrderState()) {
    getCustomerByIdOrden(idOrder);
  }

  Future<void> getCustomerByIdOrden(int? idOrder) async {
    try {
      state = state.copyWith(isLoading: true);

      final customer =
          await customerOrderRepository.getCustomerByIdOrder(idOrder!);

      state = state.copyWith(isLoading: false, customer: customer);
    } catch (e) {
      //state = state.copyWith(isLoading: false);
      // 404 product not found
      print(e);
    }
  }
}

class CustomerOrderState {
  final bool isLoading;
  final bool isSaving;
  final Customer? customer;
  final CustomerOrder? customerOrder;

  CustomerOrderState(
      {this.isLoading = true,
      this.isSaving = false,
      this.customer,
      this.customerOrder});

  CustomerOrderState copyWith({
    bool? isLoading,
    bool? isSaving,
    Customer? customer,
    CustomerOrder? customerOrder,
  }) =>
      CustomerOrderState(
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        customer: customer ?? this.customer,
        customerOrder: customerOrder ?? this.customerOrder,
      );
}
