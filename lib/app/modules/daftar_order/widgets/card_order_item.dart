// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/list_order_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_order/detail_order.dart';

// ignore: must_be_immutable
class CardOrderItem extends StatelessWidget {
  Order dataOrderItem;
  CardOrderItem({
    super.key,
    required this.dataOrderItem,
  });

  @override
  Widget build(BuildContext context) {
    final countProduct = dataOrderItem.attributes!.idProducts!.data!.length;
    final countIdFirst = dataOrderItem.attributes!.items!
        .where((e) => e.id == dataOrderItem.attributes!.items![0].id)
        .length;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return DetailOrder(
              dataOrderItem: dataOrderItem,
            );
          },
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        padding: const EdgeInsets.all(
          10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorWhite,
          boxShadow: [
            BoxShadow(
              color: colorBlack.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 15,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.shopping_bag,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Belanja',
                          style: poppinsBlack.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy')
                              .format(dataOrderItem.attributes!.createdAt!),
                          style: poppinsBlack.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    dataOrderItem.attributes!.statusOrder == "waiting_payment"
                        ? Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.yellow[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Pending',
                              style: poppinsBlack.copyWith(
                                color: Colors.yellow[900],
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : dataOrderItem.attributes!.statusOrder ==
                                "success_payment"
                            ? Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.green[300],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  'Success',
                                  style: poppinsBlack.copyWith(
                                    color: Colors.green[900],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            : dataOrderItem.attributes!.statusOrder ==
                                    "error_payment"
                                ? Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.red[300],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: poppinsBlack.copyWith(
                                        color: Colors.red[900],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                : Container(),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.more_vert,
                      size: 30,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            const SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        '$urlBase${dataOrderItem.attributes!.items![0].attributes!.productCover!.data!.attributes!.url}',
                      ),
                    ),
                    border: Border.all(
                      width: 1,
                      color: colorBlack,
                    ),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataOrderItem
                            .attributes!.items![0].attributes!.productName!,
                        style: poppinsBlack.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$countIdFirst barang',
                        style: poppinsBlack.copyWith(
                          color: colorBlack.withOpacity(0.4),
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            countProduct == 1
                ? const SizedBox()
                : Text(
                    '+${countProduct - 1} produk lainnya',
                    style: poppinsBlack.copyWith(
                      fontSize: 12,
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Belanja',
                      style: poppinsBlack.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      CurrencyFormat.convertToIdr(
                          dataOrderItem.attributes!.totalPrice!, 0),
                      style: poppinsBlack.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                dataOrderItem.attributes!.statusOrder == "success_payment"
                    ? Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[700],
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Ulas',
                                style: poppinsWhite.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(
                                color: const Color.fromRGBO(56, 142, 60, 1),
                              ),
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Beli Lagi',
                                style: poppinsWhite.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
