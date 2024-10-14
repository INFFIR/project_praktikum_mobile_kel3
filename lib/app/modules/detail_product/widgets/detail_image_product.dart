// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';

class DetailImageProduct extends StatelessWidget {
  final String urlImage;
  const DetailImageProduct({
    super.key,
    required this.urlImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 369,
          width: 341,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('$urlBase$urlImage'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 20,
          child: Container(
            height: 57,
            width: 61,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorWhite,
            ),
            child: const Center(
              child: Icon(
                Icons.favorite_border_rounded,
                size: 35,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
