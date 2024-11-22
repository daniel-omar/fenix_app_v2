import 'package:fenix_app_v2/features/orders/domain/entities/order.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // _ImageViewer(images: product.images),
        Text(
          order.numeroOrden,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
