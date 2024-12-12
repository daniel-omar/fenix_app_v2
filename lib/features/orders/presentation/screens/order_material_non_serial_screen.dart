import 'dart:io';

import 'package:fenix_app_v2/features/orders/domain/domain.dart' as Domain;
import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:fenix_app_v2/features/shared/widgets/custom_elevated_icon_button.dart';
import 'package:fenix_app_v2/features/shared/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderMaterialNoSeriadoView extends ConsumerStatefulWidget {
  final Domain.Order order;

  const OrderMaterialNoSeriadoView({super.key, required this.order});

  @override
  // ignore: library_private_types_in_public_api
  _OrderMaterialNoSeriadoView createState() => _OrderMaterialNoSeriadoView();
}

class _OrderMaterialNoSeriadoView
    extends ConsumerState<OrderMaterialNoSeriadoView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref
          .read(orderMaterialsNotSerialProvider.notifier)
          .getOrderMaterialsGroup();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final orderMaterialsNotSerialState =
        ref.watch(orderMaterialsNotSerialProvider);

    final double width = MediaQuery.of(context).size.width;

    return orderMaterialsNotSerialState.orderMaterialsGroupNotSerial!.isNotEmpty
        ? Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: orderMaterialsNotSerialState
                      .orderMaterialsGroupNotSerial!.length,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final orderMaterialGroup = orderMaterialsNotSerialState
                        .orderMaterialsGroupNotSerial![index];

                    return ExpansionTile(
                      title: Text(
                          '${orderMaterialGroup.category!.nombreCategoria}'),
                      initiallyExpanded: true,
                      children: <Widget>[
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Center(child: Text("")),
                            SizedBox(
                              width: 180.0,
                              child: Center(child: Text("Material")),
                            ),
                            Center(child: Text("Cantidad")),
                          ],
                        ),
                        ...orderMaterialGroup.materials!.map(
                          (e) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: OrderMaterialNoSeriado(
                                  key: ValueKey(
                                      '${orderMaterialGroup.idCategoria}-${e.idMaterial}'),
                                  orderMaterial: e,
                                  index:
                                      orderMaterialGroup.materials!.indexOf(e)),
                            );
                          },
                        )
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20)
            ],
          )
        : const CircularProgressIndicator();
  }
}

class OrderMaterialNoSeriado extends ConsumerStatefulWidget {
  final Domain.OrderMaterial orderMaterial;
  final int index;

  const OrderMaterialNoSeriado(
      {super.key, required this.orderMaterial, required this.index});

  @override
  // ignore: library_private_types_in_public_api
  _OrderMaterialNoSeriado createState() => _OrderMaterialNoSeriado();
}

class _OrderMaterialNoSeriado extends ConsumerState<OrderMaterialNoSeriado> {
  TextEditingController textEditingController = TextEditingController();
  bool? esSeleccionado = false;

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.orderMaterial.cantidad.toString();
    esSeleccionado = widget.orderMaterial.esSeleccionado;
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // ignore: no_leading_underscores_for_local_identifiers
    final _orderMaterial = widget.orderMaterial;
    final index = widget.index;
    // ignore: unused_local_variable
    const TextStyle styleFieldValue = TextStyle(fontSize: 16);

    void _changeCantidad(String cantidad) {
      if (cantidad.startsWith("0")) {
        cantidad = cantidad.replaceFirst("0", "");
      }

      if (cantidad == "") {
        cantidad = "0";
      }

      setState(() {
        textEditingController.text = cantidad;
        ref
            .watch(orderMaterialsNotSerialProvider.notifier)
            .updateOrderMaterialAnItem(
                _orderMaterial.idCategoria, index, int.parse(cantidad));
      });
    }

    void _changeSeleccionado(bool esSeleccionado) {
      setState(() {
        this.esSeleccionado = esSeleccionado;
        ref
            .watch(orderMaterialsNotSerialProvider.notifier)
            .checkedOrderMaterialAnItem(
                _orderMaterial.idCategoria, index, esSeleccionado);
      });
    }

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
              Checkbox(
                checkColor: Colors.white,
                //fillColor: MaterialStateProperty.resolveWith(getColor),
                value: esSeleccionado,
                onChanged: (bool? value) {
                  _changeSeleccionado(value!);
                },
              ),
              CustomTextFormField(
                readOnly: true,
                isTopField: true,
                initialValue: _orderMaterial.material?.nombreMaterial,
                width: 210,
              ),
              CustomTextFormField(
                isTopField: true,
                //initialValue: _orderMaterial.cantidad.toString(),
                keyboardType: TextInputType.number,
                listTextInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                width: 70,
                textEditingController: textEditingController,
                onChanged: _changeCantidad,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
