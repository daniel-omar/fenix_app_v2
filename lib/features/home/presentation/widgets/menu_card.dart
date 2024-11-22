import 'package:fenix_app_v2/features/home/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:fenix_app_v2/features/products/domain/domain.dart';

class MenuCard extends StatelessWidget {
  final Menu menu;

  const MenuCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          menu.nombreMenu,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
