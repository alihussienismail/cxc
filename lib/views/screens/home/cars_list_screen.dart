import 'dart:developer';

import 'package:carsxchange/constants/colors.dart';
import 'package:carsxchange/models/car_model.dart';
import 'package:carsxchange/providers/cars_provider.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../widgets/home/bid_card.dart';
import '../single_car/single_car_screen.dart';

class HomePageCars extends StatefulWidget {
  String filterType;

  HomePageCars({Key key, @required this.filterType}) : super(key: key);

  @override
  State<HomePageCars> createState() => _HomePageCarsState();
}

class _HomePageCarsState extends State<HomePageCars> {
  int newSection = 0;
  final PagingController<int, Car> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<Car> newItems = await Provider.of<Cars>(context, listen: false)
          .getCarsList(pageKey, widget.filterType);
      // list of cars

      // Live title => endDate.isAfter(now) && Index ===0;
      // Add offer Title => endDate.isBefore(Now) && (Previousitem.endDate.isAfter(now) || Index === 0)

      if (pageKey == 1) {
        for (int i = 0; i < newItems.length; i++) {
          if (newItems[i].auction.endAt.isAfter(DateTime.now()) && i == 0) {
            newItems[i].isFirstLive = true;
            log("Is first live: ${i}");
          } else if (newItems[i].auction.endAt.isBefore(DateTime.now()) &&
              (i == 0 ||
                  (i > 0 &&
                      newItems[i - 1].auction.endAt.isAfter(DateTime.now())))) {
            newItems[i].isFirstExpired = true;
            log("Is first expired: ${i}");
            break;
          } else {
            log("Is not ffirst live nor first expired: ${i}");
          }
        }
      }
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: kPrimaryColor,
        onRefresh: () async => _pagingController.refresh(),
        child: PagedListView<int, Car>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Car>(
            itemBuilder: (context, item, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleCarScreen(
                        carId: item.id,
                      ),
                    ),
                  ).then((value) {
                    // refresh page as some data might be already updated
                    _pagingController.refresh();
                  });
                },
                child: BidCard(
                  car: item,
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
