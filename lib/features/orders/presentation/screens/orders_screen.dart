import 'package:fenix_app_v2/features/auth/presentation/providers/auth_provider.dart';
import 'package:fenix_app_v2/features/products/presentation/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:fenix_app_v2/features/shared/shared.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _OrdersView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon(Icons.add),
        onPressed: () {
          context.push('/product/new');
        },
      ),
    );
  }
}

class _OrdersView extends ConsumerStatefulWidget {
  const _OrdersView();

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();
  int idUsuario = 0;

  @override
  void initState() {
    super.initState();
    final authState = ref.watch(authProvider);
    if (authState.user != null) idUsuario = authState.user!.idUsuario!;

    ref.read(ordersProvider.notifier).getOrdersByTechnical(idUsuario);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,
        itemCount: ordersState.orders.length,
        itemBuilder: (context, index) {
          final order = ordersState.orders[index];
          return GestureDetector(
              onTap: () => context.push('/order/${order.idOrden}'),
              child: OrderCard(order: order));
        },
      ),
    );
  }
}
