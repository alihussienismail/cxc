import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carsxchange/constants/global.dart';
import 'package:carsxchange/models/bid_offer_response_model.dart';
import 'package:carsxchange/providers/auth_provider.dart';
import 'package:carsxchange/providers/cars_provider.dart';
import 'package:carsxchange/providers/misc_provider.dart';
import 'package:carsxchange/views/widgets/error_placeholder.dart';
import 'package:carsxchange/views/widgets/home/add_bid_price_card.dart';
import 'package:carsxchange/views/widgets/home/back_arrow_single_car.dart';
import 'package:carsxchange/views/widgets/home/titleAndPrice.dart';
import 'package:carsxchange/views/widgets/loader_widget.dart';
import 'package:carsxchange/views/widgets/single_car/car_gallery_overlay.dart';
import 'package:carsxchange/views/widgets/single_car/expandable_detail.dart';
import 'package:carsxchange/views/widgets/single_car/exterior_as_svg.dart';
import 'package:carsxchange/views/widgets/single_car/horizontal_slidable_detail.dart';
import 'package:carsxchange/views/widgets/single_car/title_and_data.dart';
import 'package:change_case/change_case.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

import '../../../constants/colors.dart';
import '../../../models/car_model.dart';
import '../../widgets/formTextField.dart';

class SingleCarScreen extends StatefulWidget {
  int carId;

  SingleCarScreen({
    Key key,
    @required this.carId,
  }) : super(key: key);

  @override
  State<SingleCarScreen> createState() => _SingleCarScreenState();
}

class _SingleCarScreenState extends State<SingleCarScreen> {
  bool _isLoading = true;
  bool _isFirstLoad = true;
  bool _isBidAddingLoading = false;
  bool _amIHighestBid = false;
  DetailedCarInfo detailedCarInfo;

  int _currentSliderIndex = 0;

  String _currentSelectedBidPrice = '';

  int currentBidPrice;

  Timer timer;

  Duration _remainingDuration = const Duration(seconds: 0);

  final CarouselController _controllerCarousel = CarouselController();

  TextEditingController controllerBid = TextEditingController();

  StreamController<Widget> overlayController =
      StreamController<Widget>.broadcast();

  @override
  void dispose() {
    overlayController.close();
    // unsubscribe from socket channel
    if (detailedCarInfo.car.auction.endAt.isAfter(DateTime.now()) &&
        detailedCarInfo != null) {
      timer.cancel();
      pusher
          .unsubscribe("private-car.auction.${detailedCarInfo.car.auction.id}");
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isFirstLoad) {
      Provider.of<Cars>(context, listen: false)
          .getCarDetails(widget.carId)
          .then((detailedCarInfoValue) {
        if (context.mounted) {
          if (detailedCarInfoValue != null) {
            controllerBid = TextEditingController(
              text: detailedCarInfoValue.car.auction.latestBid != null
                  ? (detailedCarInfoValue.car.auction.latestBid.bid + 500)
                      .toString()
                  : detailedCarInfoValue.car.auction.startPrice.toString(),
            );
            detailedCarInfo = detailedCarInfoValue;
            detailedCarInfo.car.auction.endAt.isAfter(DateTime.now())
                ? subscribeToAuctionSocket()
                : null;
            timer = startTimer();
            setState(() {
              _isFirstLoad = false;
              _isLoading = false;
              _amIHighestBid = detailedCarInfo.myBid != null &&
                  (detailedCarInfo.myBid.bid >=
                      (detailedCarInfo.car.auction.latestBid != null
                          ? detailedCarInfo.car.auction.latestBid.bid
                          : detailedCarInfo.car.auction.startPrice));
            });
          } else {
            setState(() {
              _isLoading = false;
              detailedCarInfo = null;
            });
          }
        }
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: _isLoading
            ? loaderWidget(context)
            : detailedCarInfo == null
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
                : Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            _isFirstLoad = true;
                            _isLoading = true;
                          });
                          didChangeDependencies();
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CarouselSlider(
                                    items: detailedCarInfo.car.images
                                        .map((item) => InkWell(
                                            onTap: () {
                                              SwipeImageGallery(
                                                  context: context,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return CachedNetworkImage(
                                                      imageUrl: getCarImageUrl(
                                                          detailedCarInfo.car
                                                              .images[index]),
                                                      placeholder:
                                                          (context, url) =>
                                                              const Center(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16.0),
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    );
                                                  },
                                                  onSwipe: (index) {
                                                    overlayController.add(
                                                        ImageGalleryOverlay(
                                                      title:
                                                          '${index + 1}/${detailedCarInfo.car.images.length}',
                                                    ));
                                                  },
                                                  backgroundOpacity: 0.9,
                                                  backgroundColor: Colors.black,
                                                  itemCount: detailedCarInfo
                                                      .car.images.length,
                                                  overlayController:
                                                      overlayController,
                                                  hideStatusBar: true,
                                                  initialOverlay:
                                                      ImageGalleryOverlay(
                                                    title:
                                                        '1/${detailedCarInfo.car.images.length}',
                                                  )).show();
                                            },
                                            child: PhotoView(
                                              initialScale:
                                                  PhotoViewComputedScale
                                                      .covered,
                                              imageProvider:
                                                  CachedNetworkImageProvider(
                                                getCarImageUrl(item),
                                              ),
                                            )))
                                        .toList(),
                                    carouselController: _controllerCarousel,
                                    options: CarouselOptions(
                                        viewportFraction: 1.0,
                                        enlargeCenterPage: false,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _currentSliderIndex = index;
                                          });
                                        }),
                                  ),
                                  Positioned(
                                    right: 0,
                                    left: 0,
                                    bottom: 12,
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      children: detailedCarInfo.car.images
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        return Container(
                                          width: 8.0,
                                          height: 8.0,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withOpacity(
                                                  _currentSliderIndex ==
                                                          entry.key
                                                      ? 0.9
                                                      : 0.4)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  isEnglish
                                      ? Positioned(
                                          top: 16,
                                          left: 16,
                                          child: BackArrowCard())
                                      : Positioned(
                                          top: 16,
                                          right: 16,
                                          child: BackArrowCard()),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${detailedCarInfo.car.details.make} ${detailedCarInfo.car.details.model} ${detailedCarInfo.car.details.year}',
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              detailedCarInfo.car.auction.endAt
                                                      .isAfter(DateTime.now())
                                                  ? Text(
                                                      "Ends in ".tr() +
                                                          DateFormat('HH:mm:ss')
                                                              .format(DateTime(
                                                                      0)
                                                                  .add(
                                                                      _remainingDuration)),
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  : const SizedBox(
                                                      height: 0,
                                                    )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${detailedCarInfo.car.auction.latestBid != null ? detailedCarInfo.car.auction.latestBid.bid.toString() : detailedCarInfo.car.auction.startPrice.toString()} ${'AED'.tr()}'
                                                  .replaceAllMapped(
                                                RegExp(
                                                    r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                (Match m) => '${m[1]},',
                                              ),
                                              style: const TextStyle(
                                                  color: kPrimaryColor,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              'Highest bid'.tr(),
                                              style: const TextStyle(
                                                  color: kInactiveTextColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    TitleAndPrice(
                                      title: 'Seller Price'.tr(),
                                      price:
                                          '${detailedCarInfo.car.details.sellerPrice} '
                                                  .replaceAllMapped(
                                                RegExp(
                                                    r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                (Match m) => '${m[1]},',
                                              ) +
                                              'AED'.tr(),
                                    ),
                                    TitleAndPrice(
                                      title: 'Minimum Bid'.tr(),
                                      price:
                                          '${detailedCarInfo.car.auction.startPrice} '
                                                  .replaceAllMapped(
                                                RegExp(
                                                    r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                (Match m) => '${m[1]},',
                                              ) +
                                              'AED'.tr(),
                                    ),
                                    TitleAndPrice(
                                      title: detailedCarInfo.car.auction.endAt
                                              .isAfter(DateTime.now())
                                          ? 'Your Last Bid'.tr()
                                          : 'Minimum Acceptable Offer'.tr(),
                                      price:
                                          '${detailedCarInfo.car.auction.endAt.isBefore(DateTime.now()) ? (detailedCarInfo.car.minimumoffer != null ? detailedCarInfo.car.minimumoffer.toString() : ((detailedCarInfo.car.details.sellerPrice * 0.95).toInt()).toString()) : (detailedCarInfo.myBid != null ? detailedCarInfo.myBid.bid : 0)} ${'AED'.tr()}'
                                              .replaceAllMapped(
                                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]},',
                                      ),
                                      color: detailedCarInfo.car.auction.endAt
                                              .isBefore(DateTime.now())
                                          ? kInactiveTextColor
                                          : _amIHighestBid
                                              ? kSelectedBidCardColor
                                              : detailedCarInfo.myBid != null
                                                  ? kExpiredCardColor
                                                  : kInactiveTextColor,
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: isEnglish ? 84 : 90,
                                      child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          SlidableDetailWidget(
                                            iconAssetName:
                                                'assets/svg/distance.svg',
                                            title:
                                                '${detailedCarInfo.car.details.mileage} ${'Km'.tr()}',
                                            subTitle: 'Mileage'.tr(),
                                          ),
                                          const SizedBox(width: 12),
                                          SlidableDetailWidget(
                                            iconAssetName:
                                                'assets/svg/location.svg',
                                            title: detailedCarInfo
                                                .car.details.location,
                                            subTitle: 'Registered'.tr(),
                                          ),
                                          const SizedBox(width: 12),
                                          SlidableDetailWidget(
                                            iconAssetName:
                                                'assets/svg/power.svg',
                                            title:
                                                '${detailedCarInfo.car.details.engineSize} ${'CC'.tr()}',
                                            subTitle: 'Engine Size'.tr(),
                                          ),
                                          const SizedBox(width: 12),
                                          SlidableDetailWidget(
                                            iconAssetName:
                                                'assets/svg/color.svg',
                                            title: detailedCarInfo
                                                .car.details.exteriorColor,
                                            subTitle: 'Color'.tr(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ExpandableDetail(
                                      title: 'Car Details'.tr(),
                                      detailsList: detailedCarInfo.car.details
                                          .toJson()
                                          .entries
                                          .map((entry) {
                                        return entry.key.isEmpty
                                            ? null
                                            : TitleAndData(
                                                title:
                                                    entry.key.toCapitalCase(),
                                                data: entry.value.toString(),
                                              );
                                      }).toList(),
                                    ),
                                    ExpandableDetail(
                                      title: 'Exterior Condition'.tr(),
                                      detailsList: [
                                        detailedCarInfo.car.exterior.markers ==
                                                null
                                            ? null
                                            : CarExteriorCondition(
                                                defects: detailedCarInfo
                                                    .car.exterior.markers
                                                    .toJson()),
                                        detailedCarInfo.car.exterior
                                                    .exteriorComment ==
                                                null
                                            ? null
                                            : TitleAndData(
                                                title: 'Exterior Comment',
                                                data: detailedCarInfo.car
                                                    .exterior.exteriorComment,
                                              )
                                      ],
                                    ),
                                    ExpandableDetail(
                                      title: 'History'.tr(),
                                      detailsList: detailedCarInfo.car.history
                                          .toJson()
                                          .entries
                                          .map((entry) {
                                        return entry.key.isEmpty
                                            ? null
                                            : TitleAndData(
                                                title:
                                                    entry.key.toCapitalCase(),
                                                data: entry.value.toString(),
                                              );
                                      }).toList(),
                                    ),
                                    ExpandableDetail(
                                      title: 'Engine Transmission'.tr(),
                                      detailsList: detailedCarInfo
                                          .car.engineTransmission
                                          .toJson()
                                          .entries
                                          .map((entry) {
                                        return entry.key.isEmpty
                                            ? null
                                            : TitleAndData(
                                                title:
                                                    entry.key.toCapitalCase(),
                                                data: entry.value.toString(),
                                              );
                                      }).toList(),
                                    ),
                                    ExpandableDetail(
                                      title: 'Steering'.tr(),
                                      detailsList: detailedCarInfo.car.steering
                                          .toJson()
                                          .entries
                                          .map((entry) {
                                        return entry.key.isEmpty
                                            ? null
                                            : TitleAndData(
                                                title:
                                                    entry.key.toCapitalCase(),
                                                data: entry.value.toString(),
                                              );
                                      }).toList(),
                                    ),
                                    ExpandableDetail(
                                      title: 'Interior'.tr(),
                                      detailsList: detailedCarInfo.car.interior
                                          .toJson()
                                          .entries
                                          .map((entry) {
                                        return entry.key.isEmpty
                                            ? null
                                            : TitleAndData(
                                                title:
                                                    entry.key.toCapitalCase(),
                                                data: entry.value.toString(),
                                              );
                                      }).toList(),
                                    ),
                                    ExpandableDetail(
                                      title: 'Specs'.tr(),
                                      detailsList: detailedCarInfo.car.specs
                                          .toJson()
                                          .entries
                                          .map((entry) {
                                        return entry.key.isEmpty
                                            ? null
                                            : TitleAndData(
                                                title:
                                                    entry.key.toCapitalCase(),
                                                data: entry.value.toString(),
                                              );
                                      }).toList(),
                                    ),
                                    ExpandableDetail(
                                      title: 'Wheels'.tr(),
                                      detailsList: detailedCarInfo.car.wheels
                                          .toJson()
                                          .entries
                                          .map((entry) {
                                        return TitleAndData(
                                          title: entry.key.toCapitalCase(),
                                          data: entry.key == 'Spare_Tyre'
                                              ? entry.value == 1
                                                  ? 'Yes'
                                                  : 'No'
                                              : entry.value.toString(),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 130),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: isEnglish ? 134 : 140,
                          child: Center(
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              margin: EdgeInsets.zero,
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: bidTextFieldWidget()),
                                        const SizedBox(width: 16),
                                        _isBidAddingLoading
                                            ? const CircularProgressIndicator(
                                                color: kPrimaryColor,
                                              )
                                            : MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                onPressed: () async =>
                                                    bidOrOfferClicked(),
                                                color: kPrimaryColor,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Text(
                                                    detailedCarInfo
                                                            .car.auction.endAt
                                                            .isAfter(
                                                                DateTime.now())
                                                        ? 'Add Bid'.tr()
                                                        : 'Add Offer'.tr(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            int latestCarBid = detailedCarInfo
                                                        .car
                                                        .auction
                                                        .latestBid ==
                                                    null
                                                ? detailedCarInfo
                                                    .car.auction.startPrice
                                                : detailedCarInfo
                                                    .car.auction.latestBid.bid;
                                            setState(() {
                                              _currentSelectedBidPrice = '+500';
                                              controllerBid.text =
                                                  (latestCarBid + 500)
                                                      .toString();
                                            });
                                            bidOrOfferClicked();
                                          },
                                          child: AddBidPriceCard(
                                            addedBidPrice: '+500',
                                            currentBidPrice:
                                                _currentSelectedBidPrice,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        InkWell(
                                          onTap: () async {
                                            int latestCarBid = detailedCarInfo
                                                        .car
                                                        .auction
                                                        .latestBid ==
                                                    null
                                                ? detailedCarInfo
                                                    .car.auction.startPrice
                                                : detailedCarInfo
                                                    .car.auction.latestBid.bid;
                                            setState(() {
                                              _currentSelectedBidPrice =
                                                  '+1000';
                                              controllerBid.text =
                                                  (latestCarBid + 1000)
                                                      .toString();
                                            });
                                            bidOrOfferClicked();
                                          },
                                          child: AddBidPriceCard(
                                            addedBidPrice: '+1000',
                                            currentBidPrice:
                                                _currentSelectedBidPrice,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        InkWell(
                                          onTap: () async {
                                            setState(() {
                                              int latestCarBid = detailedCarInfo
                                                          .car
                                                          .auction
                                                          .latestBid ==
                                                      null
                                                  ? detailedCarInfo
                                                      .car.auction.startPrice
                                                  : detailedCarInfo.car.auction
                                                      .latestBid.bid;
                                              _currentSelectedBidPrice =
                                                  '+2000';
                                              controllerBid.text =
                                                  (latestCarBid + 2000)
                                                      .toString();
                                            });
                                            bidOrOfferClicked();
                                          },
                                          child: AddBidPriceCard(
                                            addedBidPrice: '+2000',
                                            currentBidPrice:
                                                _currentSelectedBidPrice,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  bidOrOfferClicked() async {
    if (detailedCarInfo.car.auction.endAt.isAfter(DateTime.now())) {
      int nowBid = controllerBid.text == "" || controllerBid.text == null
          ? 0
          : int.parse(controllerBid.text);
      int latestCarBid = (detailedCarInfo.car.auction.latestBid == null
          ? detailedCarInfo.car.auction.startPrice
          : detailedCarInfo.car.auction.latestBid.bid);
      if (controllerBid.text.isEmpty || nowBid < latestCarBid) {
        if (context.mounted) {
          CherryToast.warning(
                  title: Text(
                      "You have to add at least 500 AED more than the highest bid"
                          .tr()))
              .show(context);
        }
        return;
      }
      setState(() {
        _isBidAddingLoading = true;
      });
      bool confirmationStatus =
          await showConfirmBiddingDialog(context: context, bidAmount: nowBid);
      if (confirmationStatus == true && context.mounted) {
        BidResponse bidResponse =
            await Provider.of<Cars>(context, listen: false).addCarBid(
                detailedCarInfo.car.id, detailedCarInfo.car.auction.id, nowBid);
        if (context.mounted) {
          if (bidResponse != null) {
            if (bidResponse.success == true) {
              _amIHighestBid = true;
              await newBidAudioPlayer.stop();
              await newBidAudioPlayer.play(AssetSource('audio/newBidMine.wav'));
              CherryToast.success(
                      title: Text(
                          "${"Bid with ".tr()}$nowBid ${" AED has been placed successfully".tr()}"))
                  .show(context);
            } else if (bidResponse.success == false) {
              setState(() {
                _isBidAddingLoading = false;
              });
              CherryToast.warning(
                      title: Text(
                          "${"Couldn't add bid ".tr()}${bidResponse.message}"))
                  .show(context);
              return;
            }
          } else {
            setState(() {
              _isBidAddingLoading = false;
            });
            CherryToast.error(
                    title: Text("Error occurred while adding bid".tr()))
                .show(context);
            return;
          }
        }
        setState(() {
          // Update highest bid values
          detailedCarInfo.car.auction = DetailedCarAuction(
            carId: detailedCarInfo.car.id,
            endAt: detailedCarInfo.car.auction.endAt,
            id: detailedCarInfo.car.auction.id,
            latestBid: DetailedCarLatestBid(
                bid: nowBid, auctionId: detailedCarInfo.car.auction.id),
            startAt: detailedCarInfo.car.auction.startAt,
            startPrice: detailedCarInfo.car.auction.startPrice,
          );

          // if bid is mine, update my last bid UI

          detailedCarInfo.myBid = MyBid(
            bid: nowBid,
            auctionId: detailedCarInfo.car.auction.id,
            carId: detailedCarInfo.car.id,
            userId: context.read<Auth>().user.id,
            createdAt: DateTime.now(),
            id: 0,
          );

          // reset add bid button status
          _currentSelectedBidPrice = 'custom';
          controllerBid.text =
              (detailedCarInfo.car.auction.latestBid.bid).toString();
        });
      }
      setState(() {
        _isBidAddingLoading = false;
      });
    } else {
      int nowOffer = controllerBid.text == "" || controllerBid.text == null
          ? 0
          : int.parse(controllerBid.text);
      setState(() {
        _isBidAddingLoading = true;
      });
      bool confirmationStatus = await showConfirmBiddingDialog(
          context: context, bidAmount: nowOffer, type: "offer");
      if (confirmationStatus == true && context.mounted) {
        OfferResponse offerResponse =
            await Provider.of<Cars>(context, listen: false)
                .addCarOffer(detailedCarInfo.car.id, nowOffer);
        if (offerResponse != null) {
          if (offerResponse.success == true) {
            if (context.mounted) {
              CherryToast.success(
                      title: Text(
                          "${"Offer with ".tr()}$nowOffer ${" AED has been placed successfully".tr()}"))
                  .show(context);
            }
          } else if (offerResponse.success == false) {
            if (context.mounted) {
              CherryToast.warning(
                      title: Text(
                          "${"Please set you offer euqal to Minimum Acceptable Offer or more ".tr()}"))
                  .show(context);
              setState(() {
                _isBidAddingLoading = true;
              });
            }
            return;
          }
        } else {
          if (context.mounted) {
            CherryToast.error(
                    title: Text(
                        "${"Please set you offer euqal to Minimum Acceptable Offer or more ".tr()}"))
                .show(context);
            setState(() {
              _isBidAddingLoading = false;
            });
          }
          return;
        }
        if (context.mounted) {
          setState(() {
            _isBidAddingLoading = false;

            // if bid is mine, update my last bid UI

            detailedCarInfo.myOffer = MyOffer(
              amount: nowOffer,
              carId: detailedCarInfo.car.id,
              userId: context.read<Auth>().user.id,
              createdAt: DateTime.now(),
              id: 0,
            );

            // reset add bid button status
            _currentSelectedBidPrice = 'custom';
            controllerBid.text = (detailedCarInfo.myOffer.amount).toString();
          });
        }
      }
    }
  }

  Widget bidTextFieldWidget() {
    return FormTextField(
      readonly: false,
      controller: controllerBid,
      label: detailedCarInfo.car.auction.endAt.isAfter(DateTime.now())
          ? 'Bid'.tr()
          : 'Offer'.tr(),
      TextInputType: TextInputType.number,
      onChanged: (val) {
        setState(() {
          _currentSelectedBidPrice = "custom";
        });
      },
    );
  }

  Timer startTimer() {
    _remainingDuration =
        detailedCarInfo.car.auction.endAt.difference(DateTime.now());
    return Timer.periodic(const Duration(seconds: 1), (_) {
      _remainingDuration =
          detailedCarInfo.car.auction.endAt.difference(DateTime.now());
      if (_remainingDuration.inSeconds > 1) {
        setState(() {
          _remainingDuration =
              detailedCarInfo.car.auction.endAt.difference(DateTime.now());
        });
      } else {
        timer.cancel();
        pusher.unsubscribe(
            "private-car.auction.${detailedCarInfo.car.auction.id}");
      }
    });
  }

  subscribeToAuctionSocket() async {
    try {
      Channel channel = pusher
          .subscribe("private-car.auction.${detailedCarInfo.car.auction.id}");
      channel.bind("NewBid", (PusherEvent event) async {
        Map eventDecoded = jsonDecode(event.data);

        if (context.mounted) {
          // Update highest bid values
          detailedCarInfo.car.auction = DetailedCarAuction(
            carId: detailedCarInfo.car.id,
            endAt: DateTime.parse(eventDecoded["auction"]["end_at"]),
            id: detailedCarInfo.car.auction.id,
            latestBid: DetailedCarLatestBid(
                bid: eventDecoded["auction"]["last_bid"],
                auctionId: detailedCarInfo.car.auction.id),
            startAt: detailedCarInfo.car.auction.startAt,
            startPrice: detailedCarInfo.car.auction.startPrice,
          );
          // if bid is mine, update my last bid UI
          if (eventDecoded["auction"]["last_bid_dealer"] ==
              context.read<Auth>().user.id) {
            detailedCarInfo.myBid = MyBid(
              bid: eventDecoded["auction"]["last_bid"],
              auctionId: detailedCarInfo.car.auction.id,
              carId: detailedCarInfo.car.id,
              userId: context.read<Auth>().user.id,
              createdAt: DateTime.now(),
              id: 0,
            );
          } else if (_amIHighestBid == true) {
            _amIHighestBid = false;
            CherryToast.warning(title: Text('You have been outbidden'.tr()))
                .show(context);
            await newBidAudioPlayer.stop();
            await newBidAudioPlayer.play(AssetSource('audio/newBidOther.wav'));
          }

          if (context.mounted) {
            setState(() {
              // reset add bid button status
              _currentSelectedBidPrice = 'custom';
              controllerBid.text =
                  (detailedCarInfo.car.auction.latestBid.bid).toString();
            });
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        log("ERRR: $e");
      }
    }
  }
}
