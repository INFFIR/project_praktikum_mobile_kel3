import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_praktikum_mobile_kel3/app/bloc/checkout/checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlobalData.widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1,
              color: Colors.black,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_rounded),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 50,
                height: 35,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(
                          color: _selectedIndex == 2
                              ? colorBlack
                              : colorBlack.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                          border: Border.all(
                            width: 2,
                            color: colorWhite,
                          ),
                        ),
                        child: BlocBuilder<CheckoutBloc, CheckoutState>(
                          builder: (context, state) {
                            if (state is CheckoutLoaded) {
                              return Center(
                                child: Text(
                                  state.items.length.toString(),
                                  style: poppinsWhite.copyWith(
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            }
                            return Center(
                              child: Text(
                                '0',
                                style: poppinsWhite.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Center(child: Icon(Icons.local_mall_outlined)),
                  ],
                ),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: colorBlack,
          unselectedItemColor: colorBlack.withOpacity(0.4),
          showUnselectedLabels: true,
          selectedLabelStyle: poppinsBlack,
          unselectedLabelStyle: poppinsBlack.copyWith(
            color: colorBlack.withOpacity(0.4),
          ),
          elevation: 8,
        ),
      ),
    );
  }
}
