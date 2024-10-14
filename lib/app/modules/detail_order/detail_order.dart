// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/list_order_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_order/widgets/card_detail_order_item.dart';

class DetailOrder extends StatelessWidget {
  Order dataOrderItem;

  DetailOrder({
    super.key,
    required this.dataOrderItem,
  });

  @override
  Widget build(BuildContext context) {
    final dataProduct = dataOrderItem.attributes!.items!;
    final totalPriceItem = dataProduct.fold(
        0,
        (previousValue, element) =>
            previousValue + element.attributes!.productPrice!);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
        scrolledUnderElevation: 0,
        title: Center(
          child: Text(
            'Detail Transaksi',
            style: poppinsBlack.copyWith(
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dataOrderItem.attributes!.statusOrder ==
                                "waiting_payment"
                            ? 'Menunggu Pembayaran'
                            : dataOrderItem.attributes!.statusOrder ==
                                    "success_payment"
                                ? "Selesai"
                                : dataOrderItem.attributes!.statusOrder ==
                                        "error_payment"
                                    ? "Dibatalkan"
                                    : "",
                        style: poppinsBlack.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Lihat Detail',
                        style: poppinsBlack.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.green[700],
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nomor Invoice nanti di sini (ID : ${dataOrderItem.id})',
                      style: poppinsBlack.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Lihat Invoice',
                      style: poppinsBlack.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.green[700],
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tanggal Pembelian',
                      style: poppinsBlack.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      DateFormat('dd MMMM yyyy, hh:mm WIB')
                          .format(dataOrderItem.attributes!.createdAt!),
                      style: poppinsBlack.copyWith(
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 10.0,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(
                          start: 1.0, end: 1.0),
                      height: 2.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detail Produk',
                          style: poppinsBlack.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'NAMA TOKO',
                              style: poppinsBlack.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.chevron_right,
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          dataOrderItem.attributes!.idProducts!.data!.length,
                      itemBuilder: (context, index) {
                        return CardDetailOrderItem(
                          dataItem: dataOrderItem
                              .attributes!.idProducts!.data![index],
                          dataSemua: dataOrderItem.attributes!.items!,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 10.0,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsetsDirectional.only(
                              start: 1.0, end: 1.0),
                          height: 2.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rincian Pembayaran',
                          style: poppinsBlack.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Metode Pembayaran',
                              style: poppinsBlack.copyWith(
                                fontSize: 12,
                                color: colorBlack.withOpacity(0.7),
                              ),
                            ),
                            Text(
                              'BCA Virtual Account',
                              style: poppinsBlack.copyWith(
                                fontSize: 12,
                                color: colorBlack.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Harga (${dataProduct.length} barang)',
                              style: poppinsBlack.copyWith(
                                fontSize: 12,
                                color: colorBlack.withOpacity(0.7),
                              ),
                            ),
                            Text(
                              CurrencyFormat.convertToIdr(totalPriceItem, 0),
                              style: poppinsBlack.copyWith(
                                fontSize: 12,
                                color: colorBlack.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Ongkos Kirim (${dataOrderItem.attributes!.beratSemuaBarang} g)',
                              style: poppinsBlack.copyWith(
                                fontSize: 12,
                                color: colorBlack.withOpacity(0.7),
                              ),
                            ),
                            Text(
                              CurrencyFormat.convertToIdr(
                                  dataOrderItem.attributes!.shippingCost!, 0),
                              style: poppinsBlack.copyWith(
                                fontSize: 12,
                                color: colorBlack.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        dataOrderItem.attributes!.discount! != 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Diskon Barang',
                                    style: poppinsBlack.copyWith(
                                      fontSize: 12,
                                      color: colorBlack.withOpacity(0.7),
                                    ),
                                  ),
                                  Text(
                                    '-${CurrencyFormat.convertToIdr(dataOrderItem.attributes!.discount!, 0)}',
                                    style: poppinsBlack.copyWith(
                                      fontSize: 12,
                                      color: colorBlack.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Belanja',
                              style: poppinsBlack.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              CurrencyFormat.convertToIdr(
                                  dataOrderItem.attributes!.totalPrice!, 0),
                              style: poppinsBlack.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
