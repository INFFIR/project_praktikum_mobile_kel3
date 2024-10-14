import 'package:flutter/material.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';

// ignore: must_be_immutable
class CategoryBar extends StatelessWidget {
  CategoryBar({super.key});

  List tabContent = [
    {
      'name': 'All',
      'isActive': true,
    },
    {
      'name': 'Men',
      'isActive': false,
    },
    {
      'name': 'Women',
      'isActive': false,
    },
    {
      'name': 'Kids',
      'isActive': false,
    },
    {
      'name': 'Sports',
      'isActive': false,
    },
    {
      'name': 'Home & Lifestyle',
      'isActive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(
            width: 25,
          ),
          Row(
            children: tabContent
                .map(
                  (item) => ItemCategory(
                    nameCategory: item['name'],
                    isActive: item['isActive'],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ItemCategory extends StatelessWidget {
  bool isActive;
  String nameCategory;
  ItemCategory({
    super.key,
    this.isActive = false,
    required this.nameCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      margin: const EdgeInsets.only(
        right: 15,
      ),
      height: 38,
      decoration: BoxDecoration(
        color: isActive ? colorBlack : const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Center(
        child: Text(
          nameCategory,
          style: isActive
              ? poppinsWhite.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )
              : poppinsBlack.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
        ),
      ),
    );
  }
}
