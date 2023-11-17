import 'package:carsxchange/constants/global.dart';
import 'package:carsxchange/views/widgets/button_bar.dart';
import 'package:carsxchange/views/widgets/svg_asset.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../profile/account_home_screen.dart';
import 'cars_list_screen.dart';
import 'cars_list_screen_hot.dart';
import 'cars_list_screen_sold.dart';
import 'my_bids_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  static const TextStyle optionStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    MyBidsScreen(),
    HomePageCars(filterType: "all"),
    const AccountHomeScreen(),
  ];

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  void _onItemTapped(int index) {
    setState(() {
      selectedNavigationIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundHomeColor,
      body: SafeArea(
          child: selectedNavigationIndex != 1
              ? HomeScreen._widgetOptions.elementAt(selectedNavigationIndex)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DefaultTabController(
                    length: 4,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            Container(
                              height: isEnglish ? 46 : 52,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: ButtonsTabBar(
                                physics: const NeverScrollableScrollPhysics(),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                backgroundColor: kPrimaryColor,
                                buttonMargin: const EdgeInsets.all(8),
                                labelStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                                unselectedLabelStyle: const TextStyle(
                                    fontSize: 12,
                                    color: kInactiveTextColor,
                                    fontWeight: FontWeight.w400),
                                unselectedBackgroundColor: kBackgroundHomeColor,
                                radius: 8,
                                tabs: [
                                  Tab(
                                    text: 'All Cars'.tr(),
                                  ),
                                  Tab(
                                    text: 'Live'.tr(),
                                  ),
                                  Tab(
                                    text: 'Hot Deals'.tr(),
                                  ),
                                  Tab(
                                    text: 'Sold Cars'.tr(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              HomePageCars(filterType: "all"),
                              HomePageCars(filterType: "live"),
                              HomePageCarsHot(filterType: "custom"),
                              HomePageCarsSold(filterType: "sold"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Column(
              children: [
                selectedNavigationIndex == 0
                    ? svgAsset('assets/svg/bids_active.svg')
                    : svgAsset('assets/svg/bids_inactive.svg'),
                const SizedBox(height: 4),
                Text(
                  'Bids'.tr(),
                  style: TextStyle(
                      color: selectedNavigationIndex == 0
                          ? kPrimaryColor
                          : kGrayInactiveColor),
                ),
              ],
            ),
            label: 'Bids'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 58,
                  decoration: const BoxDecoration(
                      color: kPrimaryColor, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: svgAsset('assets/svg/logo_white.svg'),
                  )),
            ),
            label: 'Home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                selectedNavigationIndex == 2
                    ? svgAsset('assets/svg/account_active.svg')
                    : svgAsset('assets/svg/account_inactive.svg'),
                const SizedBox(height: 4),
                Text(
                  'Account'.tr(),
                  style: TextStyle(
                      color: selectedNavigationIndex == 2
                          ? kPrimaryColor
                          : kGrayInactiveColor),
                ),
              ],
            ),
            label: 'Account'.tr(),
          ),
        ],
        currentIndex: selectedNavigationIndex,
        selectedItemColor: kPrimaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
