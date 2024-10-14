import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/list_order/list_order_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/auth_local_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/auth_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/first_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/account/widgets/account_settings.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/account/widgets/item_section.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/auth/login_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/daftar_order/daftar_order.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User? user;
  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    user = await AuthLocalDatasource().getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                color: colorBlack,
              ),
              height: 294,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 60,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        color: Colors.white,
                        Icons.settings,
                        size: 40,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Settings',
                        style: poppinsWhite.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: user != null
                              ? () async {
                                  // Logout
                                  await AuthLocalDatasource().removeAuthData();
                                  if (mounted) {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return const FirstPage();
                                      },
                                    ));
                                  }
                                }
                              : () {
                                  // Login
                                  if (mounted) {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return const LoginPage();
                                      },
                                    ));
                                  }
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                user != null ? 'Logout' : 'Login',
                                style: poppinsBlack.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 30,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: colorBlack.withOpacity(0.4),
                              spreadRadius: 5,
                              blurRadius: 7)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 25,
                        right: 25,
                        left: 25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.account_circle_rounded,
                                size: 40,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                user != null ? user!.username : '-',
                                style: poppinsBlack.copyWith(
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 24,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Aktivitas saya',
                                style: poppinsBlack.copyWith(
                                  fontSize: 18,
                                  color: colorBlack.withOpacity(0.4),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ItemSection(
                                name: 'Daftar Transaksi',
                                onTap: () {
                                  if (user != null) {
                                    context.read<ListOrderBloc>().add(
                                        const ListOrderEvent.getListOrder());
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return const DaftarOrder();
                                      },
                                    ));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ));
                                  }
                                },
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ItemSection(
                                name: 'Wishlist',
                                onTap: () {},
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 24,
                          ),
                          const AccountSettings(),
                          const Divider(),
                          const SizedBox(
                            height: 25,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'More',
                                style: poppinsBlack.copyWith(
                                  fontSize: 18,
                                  color: colorBlack.withOpacity(0.4),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ItemSection(
                                name: 'About us',
                                onTap: () {},
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ItemSection(
                                name: 'Privacy policy',
                                onTap: () {},
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
