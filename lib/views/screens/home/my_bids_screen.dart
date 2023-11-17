import 'package:carsxchange/constants/colors.dart';
import 'package:carsxchange/models/my_bid.dart';
import 'package:carsxchange/providers/cars_provider.dart';
import 'package:carsxchange/views/screens/single_car/single_car_screen.dart';
import 'package:carsxchange/views/widgets/error_placeholder.dart';
import 'package:carsxchange/views/widgets/home/my_bid_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBidsScreen extends StatefulWidget {
  MyBidsScreen({Key key}) : super(key: key);

  @override
  State<MyBidsScreen> createState() => _MyBidsScreenState();
}

class _MyBidsScreenState extends State<MyBidsScreen> {
  List<MyCarBid> myCarBids;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    Provider.of<Cars>(context, listen: false).getMyCarBids().then((value) {
      myCarBids = value;
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          )
        : myCarBids == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  errorWidget(context),
                  Builder(
                    builder: (context) => MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: kPrimaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          child: Text(
                            'Try Again'.tr(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            didChangeDependencies();
                          });
                        }),
                  )
                ],
              )
            : RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _isLoading = true;
                    didChangeDependencies();
                  });
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'My Bids'.tr(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: kBackAppIconColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: myCarBids.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SingleCarScreen(
                                          carId: myCarBids[index].carId,
                                        ),
                                      ),
                                    ).then((value) {
                                      setState(() {
                                        _isLoading = true;
                                        didChangeDependencies();
                                      });
                                    });
                                  },
                                  child: MyBidCard(
                                    myCarBid: myCarBids[index],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              );
  }
}
