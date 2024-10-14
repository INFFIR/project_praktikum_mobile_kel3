// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';

// ignore: must_be_immutable
class ItemSection extends StatelessWidget {
  String name;
  VoidCallback onTap;
  Icon icon;
  ItemSection({
    super.key,
    required this.name,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: poppinsBlack.copyWith(
                fontSize: 18,
              ),
            ),
          ),
          icon,
        ],
      ),
    );
  }
}
