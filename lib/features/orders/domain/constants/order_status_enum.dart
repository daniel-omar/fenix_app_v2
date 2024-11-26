import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:flutter/material.dart';

class OrderStatusEnum {
  Color? color;
  OrderStatus orderStatus;

  OrderStatusEnum({this.color, required this.orderStatus}) {
    setColor(orderStatus);
  }

  setColor(OrderStatus orderStatus) {
    switch (orderStatus.idEstadoOrden) {
      case 1:
        color = const Color.fromARGB(255, 13, 13, 252);
        break;
      case 2:
        color = const Color.fromARGB(255, 87, 39, 176);
        break;
      case 3:
        color = Colors.amber;
        break;
      case 4:
        color = const Color.fromARGB(255, 7, 255, 222);
        break;
      case 5:
        color = const Color.fromARGB(255, 62, 220, 96);
        break;
      case 6:
        color = const Color.fromARGB(255, 196, 18, 5);
        break;
      default:
        color = null;
    }
  }

  Color? getColor() {
    return color;
  }
}
