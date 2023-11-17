import 'package:carsxchange/models/my_offer.dart';
import 'package:carsxchange/providers/cars_provider.dart';
import 'package:carsxchange/views/screens/single_car/single_car_screen.dart';
import 'package:carsxchange/views/widgets/error_placeholder.dart';
import 'package:carsxchange/views/widgets/home/my_offer_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/global.dart';

class MyOffersScreen extends StatefulWidget {
  MyOffersScreen({Key key}) : super(key: key);

  @override
  State<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends State<MyOffersScreen> {
  List<MyCarOffer> myCarOffers;
  bool _isLoading = true;
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    if (_isFirstLoad) {
      Provider.of<Cars>(context, listen: false).getMyCarOffers().then((value) {
        myCarOffers = value;
        setState(() {
          _isFirstLoad = false;
          _isLoading = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        leadingWidth: 60,
        backgroundColor: kBackgroundHomeColor,
        elevation: 0.0,
        leading: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: isEnglish ? 20 : 0, right: isEnglish ? 0 : 20),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  height: 40,
                  width: 40,
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: kBackAppIconColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          'My Offers'.tr(),
          style: const TextStyle(
              color: kBackAppIconColor,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isLoading = true;
          });
          didChangeDependencies();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        ),
                      )
                    : myCarOffers == null
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
                                        _isFirstLoad = true;
                                        _isLoading = true;
                                        didChangeDependencies();
                                      });
                                    }),
                              )
                            ],
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: myCarOffers.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SingleCarScreen(
                                          carId: myCarOffers[index].carId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: MyOffersCard(
                                    myCarOffer: myCarOffers[index],
                                  ),
                                ),
                              );
                            })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
