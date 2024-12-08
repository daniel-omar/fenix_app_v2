import 'package:fenix_app_v2/features/auth/presentation/providers/auth_provider.dart';
import 'package:fenix_app_v2/features/orders/domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:fenix_app_v2/features/shared/shared.dart';

class OrderMaterialUsedScreen extends ConsumerWidget {
  final int idOrder;

  const OrderMaterialUsedScreen({super.key, required this.idOrder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Materiales usados'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _OrderMaterialUsedView(),
      floatingActionButton: orderState.isLoading
          ? null
          : (orderState.order!.estadoOrden.idEstadoOrden != 2
              ? null
              : FloatingActionButton.extended(
                  onPressed: () {
                    if (orderState.order == null) return;
                    context.push('/order_client/${orderState.idOrden}');
                  },
                  label: const Text(
                    "Siguiente",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
    );
  }
}

class _OrderMaterialUsedView extends ConsumerStatefulWidget {
  const _OrderMaterialUsedView();

  @override
  __OrderMaterialUsedViewState createState() => __OrderMaterialUsedViewState();
}

class __OrderMaterialUsedViewState
    extends ConsumerState<_OrderMaterialUsedView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);

    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: orderState.orderMaterials!.length,
            // physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final orderMaterial = orderState.orderMaterials![index];
              if (index == 0) {
                return const ListTile(
                  onTap: null,
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                  ),
                  title: Row(children: <Widget>[
                    SizedBox(
                      width: 200.0,
                      child: Center(child: Text("Material")),
                    ),
                    Expanded(child: Text("Cantidad"))
                  ]),
                );
              } else {
                return _OrderMaterialItem(orderMaterial: orderMaterial);
              }
            },
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}

class _OrderMaterialItem extends ConsumerWidget {
  final domain.OrderMaterial orderMaterial;

  const _OrderMaterialItem({required this.orderMaterial});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // ignore: unused_local_variable
    const TextStyle styleFieldValue = TextStyle(fontSize: 16);

    return Material(
      // color: Colors.amber,
      child: InkWell(
        onTap: () {
          //Navigator.of(context).pop(true);
          //Navigator.of(context).pushNamed(menu.rutaMenu);
        },
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(100),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x000005cc),
                    blurRadius: 20,
                    offset: Offset(10, 10))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomTextFormField(
                readOnly: true,
                isTopField: true,
                initialValue: orderMaterial.material?.nombreMaterial,
                width: 250,
              ),
              CustomTextFormField(
                readOnly: true,
                isTopField: true,
                initialValue: orderMaterial.cantidad.toString(),
                width: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
