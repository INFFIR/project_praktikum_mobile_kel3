import 'package:flutter/material.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';

class TopBarDetailProduct extends StatelessWidget {
  const TopBarDetailProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Details',
                style: poppinsBlack.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Stack(
            children: [
              const Icon(
                Icons.notifications_none,
                size: 30,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: colorBlack,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    border: Border.all(
                      width: 2,
                      color: colorWhite,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '1',
                      style: poppinsWhite.copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
