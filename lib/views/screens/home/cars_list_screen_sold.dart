import 'package:carsxchange/constants/colors.dart';
import 'package:carsxchange/models/car_model.dart';
import 'package:carsxchange/providers/cars_provider.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../widgets/home/bid_card_sold.dart';
import '../single_car/single_car_screen.dart';

class HomePageCarsSold extends StatefulWidget {
  String filterType;

  HomePageCarsSold({Key key, @required this.filterType}) : super(key: key);

  @override
  State<HomePageCarsSold> createState() => _HomePageCarsState();
}

class _HomePageCarsState extends State<HomePageCarsSold> {
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
          .getCarsListSold(pageKey, widget.filterType);
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
              onTap: null,
              child: BidCardSold(
                car: item,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
