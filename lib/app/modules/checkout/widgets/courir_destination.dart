import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/biaya_courir/biaya_courir_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/checkout/checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/data_checkout/data_checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/get_kota_tujuan/get_kota_tujuan_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/get_provinsi_tujuan/get_provinsi_tujuan_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/order/order_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/common/snap_widget.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/auth_local_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/request/order_request_model.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/courir_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/kota_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/provinsi_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/checkout/widgets/input_voucher.dart';

// ignore: must_be_immutable
class CourirDestination extends StatelessWidget {
  const CourirDestination({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerProvinsiTujuan = TextEditingController();
    TextEditingController controllerKotaTujuan = TextEditingController();
    TextEditingController controllerBeratBarang = TextEditingController();
    TextEditingController controllerCourirPick = TextEditingController();
    bool isAcc = false;
    String idKotaAsal = "409";
    late String idKotaTujuan;
    late String codeCourir;
    final focusNode = FocusNode();

    void showBiayaKurir() {
      if (controllerProvinsiTujuan.text.isNotEmpty &&
          controllerKotaTujuan.text.isNotEmpty &&
          controllerBeratBarang.text.isNotEmpty &&
          controllerCourirPick.text.isNotEmpty) {
        context.read<BiayaCourirBloc>().add(
              DoGetBiayaCourirEvent(
                origin: idKotaAsal,
                destination: idKotaTujuan,
                weight: controllerBeratBarang.text,
                courier: codeCourir,
              ),
            );
      } else {
        context.read<BiayaCourirBloc>().add(DoRemoveBiayaCourirEvent());
      }
    }

    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        // PROVINSI TUJUAN
        BlocBuilder<GetProvinsiTujuanBloc, GetProvinsiTujuanState>(
          builder: (context, state) {
            if (state is GetProvinsiTujuanLoading) {
              return DropdownSearch<ProvinsiModelResponse>(
                enabled: false,
                popupProps: PopupProps.dialog(
                  dialogProps: const DialogProps(
                      backgroundColor: Colors.white,
                      contentPadding: EdgeInsets.all(
                        10,
                      )),
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    autocorrect: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Provinsi Tujuan',
                      hintText: 'Cari Provinsi Tujuan',
                      labelStyle: poppinsBlack.copyWith(
                        color: colorBlack.withOpacity(0.4),
                      ),
                      hintStyle: poppinsBlack.copyWith(
                        color: colorBlack.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Provinsi Tujuan",
                    labelStyle: poppinsBlack.copyWith(
                      color: colorBlack.withOpacity(0.4),
                    ),
                  ),
                ),
              );
            }
            if (state is GetProvinsiTujuanLoaded) {
              return DropdownSearch<ProvinsiModelResponse>(
                clearButtonProps: const ClearButtonProps(
                  isVisible: true,
                ),
                popupProps: PopupProps.dialog(
                  dialogProps: const DialogProps(
                      backgroundColor: Colors.white,
                      contentPadding: EdgeInsets.all(
                        10,
                      )),
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    controller: controllerProvinsiTujuan,
                    autocorrect: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Provinsi Tujuan',
                      hintText: 'Cari Provinsi Tujuan',
                      labelStyle: poppinsBlack,
                      hintStyle: poppinsBlack.copyWith(
                        color: colorBlack.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
                items: state.dataProvinsi,
                itemAsString: (item) => item.province,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Provinsi Tujuan",
                    labelStyle: poppinsBlack,
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    controllerProvinsiTujuan.text = value.province;
                    context
                        .read<GetKotaTujuanBloc>()
                        .add(DoGetKotaTujuanEvent(int.parse(value.provinceId)));
                    context.read<DataCheckoutBloc>().add(GetDataCheckoutEvent(
                        key: 'provinsi_tujuan', value: value.toJson()));
                    showBiayaKurir();
                  } else {
                    controllerKotaTujuan.clear();
                    controllerProvinsiTujuan.clear();
                    idKotaTujuan = '';
                    context
                        .read<GetKotaTujuanBloc>()
                        .add(DoRemoveKotaTujuanEvent());
                    context.read<DataCheckoutBloc>().add(GetDataCheckoutEvent(
                        key: 'provinsi_tujuan', value: {}));
                    context.read<DataCheckoutBloc>().add(
                        GetDataCheckoutEvent(key: 'kota_tujuan', value: {}));
                    showBiayaKurir();
                  }
                },
              );
            }
            return DropdownSearch<ProvinsiModelResponse>(
              enabled: false,
              popupProps: PopupProps.dialog(
                dialogProps: const DialogProps(
                    backgroundColor: Colors.white,
                    contentPadding: EdgeInsets.all(
                      10,
                    )),
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  autocorrect: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Provinsi Tujuan',
                    hintText: 'Cari Provinsi Tujuan',
                    labelStyle: poppinsBlack,
                    hintStyle: poppinsBlack.copyWith(
                      color: colorBlack.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Provinsi Tujuan",
                  labelStyle: poppinsBlack.copyWith(
                    color: colorBlack.withOpacity(0.4),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(
          height: 25,
        ),
        // KOTA TUJUAN
        BlocBuilder<GetKotaTujuanBloc, GetKotaTujuanState>(
          builder: (context, state) {
            if (state is GetKotaTujuanLoading) {
              return DropdownSearch<KotaModelResponse>(
                enabled: false,
                itemAsString: (item) => '',
                popupProps: PopupProps.dialog(
                  dialogProps: const DialogProps(
                      backgroundColor: Colors.white,
                      contentPadding: EdgeInsets.all(
                        10,
                      )),
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    autocorrect: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Kota Tujuan',
                      hintText: 'Cari Kota Tujuan',
                      labelStyle: poppinsBlack.copyWith(
                        color: colorBlack.withOpacity(0.4),
                      ),
                      hintStyle: poppinsBlack.copyWith(
                        color: colorBlack.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Kota Tujuan",
                    labelStyle: poppinsBlack.copyWith(
                      color: colorBlack.withOpacity(0.4),
                    ),
                  ),
                ),
              );
            }
            if (state is GetKotaTujuanLoaded) {
              return DropdownSearch<KotaModelResponse>(
                clearButtonProps: const ClearButtonProps(
                  isVisible: true,
                ),
                popupProps: PopupProps.dialog(
                  dialogProps: const DialogProps(
                      backgroundColor: Colors.white,
                      contentPadding: EdgeInsets.all(
                        10,
                      )),
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    controller: controllerKotaTujuan,
                    autocorrect: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Kota Tujuan',
                      hintText: 'Cari Kota Tujuan',
                      labelStyle: poppinsBlack,
                      hintStyle: poppinsBlack.copyWith(
                        color: colorBlack.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
                items: state.dataKota,
                itemAsString: (item) => '${item.type} ${item.cityName}',
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Kota Tujuan",
                    labelStyle: poppinsBlack,
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    controllerKotaTujuan.text =
                        '${value.type} ${value.cityName}';
                    idKotaTujuan = value.cityId;
                    context.read<DataCheckoutBloc>().add(GetDataCheckoutEvent(
                        key: 'kota_tujuan', value: value.toJson()));
                    showBiayaKurir();
                  } else {
                    controllerKotaTujuan.clear();
                    idKotaTujuan = '';
                    context.read<DataCheckoutBloc>().add(
                        GetDataCheckoutEvent(key: 'kota_tujuan', value: {}));
                    showBiayaKurir();
                  }
                },
              );
            }
            return DropdownSearch<KotaModelResponse>(
              enabled: false,
              popupProps: PopupProps.dialog(
                dialogProps: const DialogProps(
                    backgroundColor: Colors.white,
                    contentPadding: EdgeInsets.all(
                      10,
                    )),
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  autocorrect: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Kota Tujuan',
                    hintText: 'Cari Kota Tujuan',
                    labelStyle: poppinsBlack.copyWith(
                      color: colorBlack.withOpacity(0.4),
                    ),
                    hintStyle: poppinsBlack.copyWith(
                      color: colorBlack.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Kota Tujuan",
                  labelStyle: poppinsBlack.copyWith(
                    color: colorBlack.withOpacity(0.4),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(
          height: 25,
        ),
        BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoaded) {
              final dataTotalWeight = state.items.fold(
                  0,
                  (previousValue, element) =>
                      previousValue + element.attributes.productWeight);
              controllerBeratBarang.text = dataTotalWeight.toString();
              context.read<DataCheckoutBloc>().add(GetDataCheckoutEvent(
                  key: 'berat_barang', value: dataTotalWeight));
              return TextField(
                enabled: false,
                focusNode: focusNode,
                controller: controllerBeratBarang,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixText: 'gram',
                  suffixStyle: poppinsBlack.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorBlack.withOpacity(0.4),
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Berat Barang',
                  hintText: 'Masukkan berat barang',
                  hintStyle: poppinsBlack.copyWith(
                    color: colorBlack.withOpacity(0.4),
                  ),
                  labelStyle: poppinsBlack.copyWith(
                    color: colorBlack.withOpacity(0.4),
                  ),
                ),
              );
            }
            return TextField(
              enabled: false,
              focusNode: focusNode,
              controller: controllerBeratBarang,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: 'gram',
                suffixStyle: poppinsBlack.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorBlack.withOpacity(0.4),
                ),
                border: const OutlineInputBorder(),
                labelText: 'Berat Barang',
                hintText: 'Masukkan berat barang',
                hintStyle: poppinsBlack.copyWith(
                  color: colorBlack.withOpacity(0.4),
                ),
                labelStyle: poppinsBlack.copyWith(
                  color: colorBlack.withOpacity(0.4),
                ),
              ),
            );
          },
        ),
        const SizedBox(
          height: 25,
        ),
        DropdownSearch<Map<String, dynamic>>(
          clearButtonProps: const ClearButtonProps(
            isVisible: true,
          ),
          popupProps: PopupProps.bottomSheet(
            searchFieldProps: TextFieldProps(
              controller: controllerCourirPick,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Cari / Pilih kurir ...',
                hintStyle: poppinsBlack.copyWith(
                  color: colorBlack.withOpacity(0.4),
                ),
              ),
              padding: const EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
              ),
            ),
            bottomSheetProps: const BottomSheetProps(
                constraints: BoxConstraints(
              maxHeight: 300,
            )),
            showSearchBox: true,
          ),
          items: const [
            {'code': 'jne', "name": 'Jalur Nugraha Eka (JNE)'},
            {'code': 'tiki', "name": 'Titipan Kilat (TIKI)'},
            {
              'code': 'pos',
              'name': 'Perusahaan Opsional Surat (POS Indonesia)'
            },
          ],
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Pihak Kurir",
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              controllerCourirPick.text = value['name'];
              codeCourir = value['code'];
              context.read<DataCheckoutBloc>().add(
                  GetDataCheckoutEvent(key: 'courir_pilihan', value: value));
              showBiayaKurir();
            } else {
              codeCourir = '';
              controllerCourirPick.clear();
              context
                  .read<DataCheckoutBloc>()
                  .add(GetDataCheckoutEvent(key: 'courir_pilihan', value: {}));
              showBiayaKurir();
              isAcc = false;
              context
                  .read<DataCheckoutBloc>()
                  .add(GetDataCheckoutEvent(key: 'ongkir', value: 0));
            }
          },
          itemAsString: (item) => item['name'],
        ),
        const SizedBox(
          height: 25,
        ),
        BlocBuilder<BiayaCourirBloc, BiayaCourirState>(
          builder: (context, state) {
            if (state is BiayaCourirLoaded) {
              final dataCourir = state.dataCourir[0];
              return DropdownSearch<CourirModalResponseCost>(
                clearButtonProps: const ClearButtonProps(
                  isVisible: true,
                ),
                popupProps: PopupProps.bottomSheet(
                    itemBuilder: (context, item, isSelected) {
                      return Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: ListTile(
                            title: Text(
                              item.service,
                              style: poppinsBlack.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              CurrencyFormat.convertToIdr(
                                  item.cost[0].value, 0),
                              style: poppinsBlack.copyWith(
                                color: colorBlack.withOpacity(0.4),
                              ),
                            ),
                            trailing: Text(
                              dataCourir.code == "pos"
                                  ? item.cost[0].etd
                                  : '${item.cost[0].etd} HARI',
                              style: poppinsBlack.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ));
                    },
                    bottomSheetProps: const BottomSheetProps(
                        constraints: BoxConstraints(
                      maxHeight: 300,
                    )),
                    title: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        right: 15,
                        left: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dataCourir.name,
                            style: poppinsBlack.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    )),
                items: dataCourir.costs,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Biaya Kurir",
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    isAcc = true;
                    context.read<DataCheckoutBloc>().add(GetDataCheckoutEvent(
                          key: 'datacosts',
                          value: {
                            "service": value.service,
                            "description": value.description,
                            "cost": {
                              "value": value.cost[0].value,
                              "etd": value.cost[0].etd,
                              "note": value.cost[0].note,
                            }
                          },
                        ));
                    context.read<DataCheckoutBloc>().add(GetDataCheckoutEvent(
                        key: 'ongkir', value: value.cost[0].value));
                  } else {
                    isAcc = false;
                    context
                        .read<DataCheckoutBloc>()
                        .add(GetDataCheckoutEvent(key: 'ongkir', value: 0));
                    context.read<DataCheckoutBloc>().add(GetDataCheckoutEvent(
                          key: 'datacosts',
                          value: {},
                        ));
                  }
                },
                itemAsString: (item) => dataCourir.code == "pos"
                    ? '${item.service} - Rp. ${item.cost[0].value} (${item.cost[0].etd})'
                    : '${item.service} - Rp. ${item.cost[0].value} (${item.cost[0].etd} HARI)',
              );
            }
            return DropdownSearch<Map<String, dynamic>>(
              enabled: false,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Biaya Kurir",
                ),
              ),
            );
          },
        ),
        const SizedBox(
          height: 25,
        ),
        const InputVoucher(),
        const SizedBox(
          height: 30,
        ),
        BlocBuilder<DataCheckoutBloc, DataCheckoutState>(
          builder: (context, state) {
            if (state is DataCheckoutLoaded) {
              if (state.dataCheckout['discount_persen'] != 0) {
                state.dataCheckout['discount'] =
                    (state.dataCheckout['subTotal'] *
                            state.dataCheckout['discount_persen']) ~/
                        100;
              } else if (state.dataCheckout['discount_persen'] == 0) {
                state.dataCheckout['discount'] = 0;
              }
              state.dataCheckout['total'] = state.dataCheckout['subTotal'] -
                  state.dataCheckout['discount'] +
                  state.dataCheckout['ongkir'] +
                  state.dataCheckout['shopping_fee'];
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Sub-total',
                          style: poppinsBlack.copyWith(
                            fontSize: 16,
                            color: colorBlack.withOpacity(0.4),
                          ),
                        ),
                      ),
                      Text(
                        CurrencyFormat.convertToIdr(
                            state.dataCheckout['subTotal'] ?? 0, 0),
                        style: poppinsBlack.copyWith(
                          fontSize: 16,
                          color: colorBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.dataCheckout['discount_persen'] != 0
                              ? 'Discount (${state.dataCheckout['discount_persen']}%)'
                              : 'Discount (%)',
                          style: poppinsBlack.copyWith(
                            fontSize: 16,
                            color: colorBlack.withOpacity(0.4),
                          ),
                        ),
                      ),
                      Text(
                        CurrencyFormat.convertToIdr(
                            state.dataCheckout['discount'] ?? 0, 0),
                        style: poppinsBlack.copyWith(
                          fontSize: 16,
                          color: colorBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Ongkos Kirim',
                          style: poppinsBlack.copyWith(
                            fontSize: 16,
                            color: colorBlack.withOpacity(0.4),
                          ),
                        ),
                      ),
                      Text(
                        CurrencyFormat.convertToIdr(
                            state.dataCheckout['ongkir'] ?? 0, 0),
                        style: poppinsBlack.copyWith(
                          fontSize: 16,
                          color: colorBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Shipping fee',
                          style: poppinsBlack.copyWith(
                            fontSize: 16,
                            color: colorBlack.withOpacity(0.4),
                          ),
                        ),
                      ),
                      Text(
                        CurrencyFormat.convertToIdr(
                            state.dataCheckout['shopping_fee'], 0),
                        style: poppinsBlack.copyWith(
                          fontSize: 16,
                          color: colorBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total',
                          style: poppinsBlack.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        CurrencyFormat.convertToIdr(
                            state.dataCheckout['total'] ?? 0, 0),
                        style: poppinsBlack.copyWith(
                          fontSize: 18,
                          color: colorBlack,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              );
            }
            return const Center(
              child: Text('Data tidak ada'),
            );
          },
        ),
        BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              loaded: (model) {
                context.read<CheckoutBloc>().add(RemoveAllFromCartEvent());
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return SnapWidget(url: model.redirectUrl);
                  },
                ));
              },
            );
          },
          child: BlocBuilder<DataCheckoutBloc, DataCheckoutState>(
            builder: (context, state) {
              if (state is DataCheckoutLoaded) {
                return GestureDetector(
                  onTap: () async {
                    if (isAcc && state.dataCheckout['shipping_address'] != "") {
                      final userId = await AuthLocalDatasource().getUserId();
                      final data = Data(
                        totalPrice: state.dataCheckout['total'],
                        deliveryAddress: state.dataCheckout['shipping_address'],
                        shippingCost: state.dataCheckout['ongkir'],
                        statusOrder: 'waiting_payment',
                        idProducts: state.dataCheckout['id_products'],
                        discount: state.dataCheckout['discount'],
                        shoppingFee: state.dataCheckout['shopping_fee'],
                        voucherData: state.dataCheckout['voucher'],
                        rajaOngkir: RajaOngkir(
                          ongkir: state.dataCheckout['ongkir'],
                          provinsiAsal: Provinsi(
                              province: state.dataCheckout['provinsi_asal']
                                  ['province'],
                              provinceId: state.dataCheckout['provinsi_asal']
                                  ['province_id']),
                          kotaAsal: Kota(
                            cityId: int.parse(
                                state.dataCheckout['kota_asal']['city_id']),
                            cityName: state.dataCheckout['kota_asal']
                                ['city_name'],
                            postalCode: int.parse(
                                state.dataCheckout['kota_asal']['postal_code']),
                            province: state.dataCheckout['kota_asal']
                                ['province'],
                            provinceId: int.parse(
                                state.dataCheckout['kota_asal']['province_id']),
                            type: state.dataCheckout['kota_asal']['type'],
                          ),
                          provinsiTujuan: Provinsi(
                              province: state.dataCheckout['provinsi_tujuan']
                                  ['province'],
                              provinceId: int.parse(
                                  state.dataCheckout['provinsi_tujuan']
                                      ['province_id'])),
                          kotaTujuan: Kota(
                            cityId: int.parse(
                                state.dataCheckout['kota_tujuan']['city_id']),
                            cityName: state.dataCheckout['kota_tujuan']
                                ['city_name'],
                            postalCode: int.parse(state
                                .dataCheckout['kota_tujuan']['postal_code']),
                            province: state.dataCheckout['kota_tujuan']
                                ['province'],
                            provinceId: int.parse(state
                                .dataCheckout['kota_tujuan']['province_id']),
                            type: state.dataCheckout['kota_tujuan']['type'],
                          ),
                          courirPilihan: CourirPilihan(
                            code: state.dataCheckout['courir_pilihan']['code'],
                            name: state.dataCheckout['courir_pilihan']['name'],
                            costs: Costs(
                              description: state.dataCheckout['datacosts']
                                  ['description'],
                              service: state.dataCheckout['datacosts']
                                  ['service'],
                              cost: Cost(
                                value: state.dataCheckout['datacosts']['cost']
                                    ['value'],
                                etd: state.dataCheckout['datacosts']['cost']
                                    ['etd'],
                                note: state.dataCheckout['datacosts']['cost']
                                    ['note'],
                              ),
                            ),
                          ),
                        ),
                        items: state.dataCheckout['items'],
                        beratSemuaBarang: state.dataCheckout['berat_barang'],
                        userId: userId,
                      );
                      final requestModel = OrderRequestModel(data: data);
                      // ignore: use_build_context_synchronously
                      context
                          .read<OrderBloc>()
                          .add(OrderEvent.doOrder(requestModel));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Data Belum Lengkap',
                        ),
                        duration: Duration(
                          seconds: 1,
                        ),
                      ));
                    }
                  },
                  child: Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color:
                          isAcc && state.dataCheckout['shipping_address'] != ''
                              ? colorBlack
                              : colorBlack.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Buat Pesanan',
                          style: poppinsWhite.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_outlined,
                          color: colorWhite,
                        )
                      ],
                    ),
                  ),
                );
              }
              return Container(
                height: 58,
                decoration: BoxDecoration(
                  color: isAcc ? colorBlack : colorBlack.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Buat Pesanan',
                      style: poppinsWhite.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_outlined,
                      color: colorWhite,
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
