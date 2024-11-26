import 'package:fenix_app_v2/features/orders/domain/constants/order_status_enum.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/order.dart';
import 'package:fenix_app_v2/features/shared/widgets/custom_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    const TextStyle styleField =
        TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    const TextStyle styleFieldValue = TextStyle(fontSize: 16);
    OrderStatusEnum orderStatusEnum =
        OrderStatusEnum(orderStatus: order.estadoOrden);

    return Material(
      // color: Colors.amber,
      child: InkWell(
        onTap: () => context.push('/order/${order.idOrden}'),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          // margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
              // border: Border.all(color: Colors.blueAccent),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x000005cc),
                    blurRadius: 20,
                    offset: Offset(10, 10))
              ]),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // const Icon(
                //   Icons.login_outlined,
                //   size: 50,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      textAlign: TextAlign.center,
                      "Numero Orden: ",
                      style: styleField,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      textAlign: TextAlign.center,
                      order.numeroOrden,
                      style: styleFieldValue,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      textAlign: TextAlign.center,
                      "Cliente: ",
                      style: styleField,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      textAlign: TextAlign.center,
                      "${order.cliente.nombreCliente} ${order.cliente.apellidoPaterno} ${order.cliente.apellidoMaterno}",
                      style: styleFieldValue,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      textAlign: TextAlign.center,
                      "Actividad: ",
                      style: styleField,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      textAlign: TextAlign.center,
                      order.actividad.nombreActividad,
                      style: styleFieldValue,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CustomFilledButton(
                    onPressed: () {},
                    text: order.estadoOrden.nombreEstado,
                    buttonColor: orderStatusEnum.getColor(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
