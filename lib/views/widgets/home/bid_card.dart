import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carsxchange/constants/global.dart';
import 'package:carsxchange/models/bid_offer_response_model.dart';
import 'package:carsxchange/models/car_model.dart';
import 'package:carsxchange/providers/cars_provider.dart';
import 'package:carsxchange/providers/misc_provider.dart';
import 'package:carsxchange/views/widgets/svg_asset.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusher_client/pusher_client.dart';

import '../../../constants/colors.dart';

class BidCard extends StatefulWidget {
  Car car;
  BidCard({Key key, @required this.car}) : super(key: key);

  @override
  State<BidCard> createState() => _BidCardState();
}

class _BidCardState extends State<BidCard> {
  Duration _remainingDuration = const Duration(seconds: 0);
  Timer timer;
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.car.auction.endAt.isAfter(DateTime.now())) {
      timer = startTimer();
      subscribeToAuctionSocket();
    }
    super.initState();
  }

  @override
  void dispose() {
    // unsubscribe from socket channel
    if (widget.car.auction.endAt.isAfter(DateTime.now())) {
      timer.cancel();
      pusher.unsubscribe("private-car.auction.${widget.car.auction.id}");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              widget.car.isFirstExpired
                  ? Row(
                      children: [
                        Text(
                          widget.car.isFirstExpired ? 'OFFERS CARS:' : '',
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              overflow: TextOverflow.ellipsis),
                        ),
                        const Divider(
                          height: 20,
                          color: kInactiveTextColor,
                        ),
                      ],
                    )
                  : Text(
                      '',
                      maxLines: 2,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 1,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis),
                    ),
              widget.car.isFirstLive
                  ? Row(
                      children: [
                        Text(
                          widget.car.isFirstLive ? 'LIVE CARS:' : '',
                          maxLines: 2,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 5, 108, 5),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Divider(
                          height: 20,
                          color: kInactiveTextColor,
                        )
                      ],
                    )
                  : Text(
                      '',
                      maxLines: 2,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 1,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 64,
                    width: 106,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      child: SizedBox(
                        height: 50,
                        child: CachedNetworkImage(
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          imageUrl: getCarImageUrl(widget.car.images.first),
                          placeholder: (context, url) => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '${widget.car.details.make} ${widget.car.details.model} ${widget.car.details.year}',
                                maxLines: 2,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(width: 4),
                            !widget.car.auction.endAt.isAfter(DateTime.now())
                                ? const SizedBox(
                                    height: 0,
                                  )
                                : Text(
                                    DateFormat('HH:mm:ss').format(
                                        DateTime(0).add(_remainingDuration)),
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SizedBox(
                                width: 12,
                                height: 12,
                                child: svgAsset('assets/svg/distance.svg')),
                            const SizedBox(width: 3),
                            Text('${widget.car.details.mileage} ${'KM'.tr()}',
                                style: const TextStyle(
                                    color: kInactiveTextColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(width: 10),
                            SizedBox(
                                width: 12,
                                height: 12,
                                child: svgAsset('assets/svg/location.svg')),
                            const SizedBox(width: 3),
                            Text(widget.car.details.location,
                                style: const TextStyle(
                                    color: kInactiveTextColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(width: 13),
                            SizedBox(
                                width: 12,
                                height: 12,
                                child: svgAsset('assets/svg/power.svg')),
                            const SizedBox(width: 2),
                            Text(
                                '${widget.car.details.engineSize} ${'CC'.tr()}',
                                style: const TextStyle(
                                    color: kInactiveTextColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                        const Divider(
                          height: 16,
                          color: kInactiveTextColor,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                widget.car.auction.endAt.isAfter(DateTime.now())
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: kActiveCardColor,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        height: 16,
                                        width: 38,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: 4,
                                                  height: 4,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white,
                                                          border: Border
                                                              .fromBorderSide(
                                                            BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 3),
                                                          ))),
                                              const SizedBox(width: 4),
                                              Text('Live'.tr(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8)),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFFFFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        height: 16,
                                        width: 38,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 4),
                                          child: Center(child: null),
                                        ),
                                      ),
                                const SizedBox(width: 8),
                                _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: kPrimaryColor,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        width: 54,
                                        height: 20,
                                        child: InkWell(
                                          onTap: () async {
                                            setState(() {
                                              _isLoading = true;
                                            });

                                            if (widget.car.auction.endAt
                                                    .isAfter(DateTime.now()) &&
                                                context.mounted) {
                                              int bidAmount;
                                              if (widget
                                                      .car.auction.latestBid !=
                                                  null) {
                                                bidAmount = widget.car.auction
                                                        .latestBid.bid +
                                                    500;
                                              } else {
                                                bidAmount = widget.car.auction
                                                        .startPrice +
                                                    500;
                                              }
                                              bool confirmationStatus =
                                                  await showConfirmBiddingDialog(
                                                      context: context,
                                                      bidAmount: bidAmount);
                                              if (confirmationStatus == true) {
                                                if (context.mounted) {
                                                  BidResponse bidOfferResponse =
                                                      await Provider.of<Cars>(
                                                              context,
                                                              listen: false)
                                                          .addCarBid(
                                                              widget.car.id,
                                                              widget.car.auction
                                                                  .id,
                                                              bidAmount);
                                                  if (context.mounted) {
                                                    if (bidOfferResponse !=
                                                        null) {
                                                      if (bidOfferResponse
                                                              .success ==
                                                          true) {
                                                        CherryToast.success(
                                                                title: Text(
                                                                    "${'Offer with'.tr()} $bidAmount placed successfully"))
                                                            .show(context);
                                                      } else if (bidOfferResponse
                                                              .success ==
                                                          false) {
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        CherryToast.warning(
                                                                title: Text(
                                                                    "${'Couldnt add bid'.tr()} ${bidOfferResponse.message}"))
                                                            .show(context);
                                                        return;
                                                      }
                                                    } else {
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      CherryToast.error(
                                                              title: Text(
                                                                  "Error occurred while adding bid"
                                                                      .tr()))
                                                          .show(context);
                                                      return;
                                                    }
                                                  }
                                                  widget.car.auction.latestBid =
                                                      LatestBid(
                                                          auctionId: widget
                                                              .car.auction.id,
                                                          bid: bidOfferResponse
                                                              .lastBid);
                                                  widget.car.auction.endAt =
                                                      bidOfferResponse.endAt;
                                                }
                                              } else {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                return;
                                              }
                                            } else {
                                              int carHighestPrice;
                                              if (widget
                                                      .car.auction.latestBid !=
                                                  null) {
                                                carHighestPrice = widget
                                                    .car.auction.latestBid.bid;
                                              } else {
                                                carHighestPrice = widget
                                                    .car.auction.startPrice;
                                              }
                                              int offerAmount =
                                                  await showEnterOfferAmountDialog(
                                                      context: context,
                                                      highestPrice:
                                                          carHighestPrice +
                                                              500);
                                              if (offerAmount != null &&
                                                  context.mounted) {
                                                bool confirmationStatus =
                                                    await showConfirmBiddingDialog(
                                                        context: context,
                                                        bidAmount: offerAmount,
                                                        type: "offer");
                                                if (confirmationStatus ==
                                                    true) {
                                                  if (context.mounted) {
                                                    OfferResponse
                                                        offerResponse =
                                                        await Provider.of<Cars>(
                                                                context,
                                                                listen: false)
                                                            .addCarOffer(
                                                                widget.car.id,
                                                                offerAmount);
                                                    if (offerResponse != null) {
                                                      if (offerResponse
                                                              .success ==
                                                          true) {
                                                        if (context.mounted)
                                                          CherryToast.success(
                                                                  title: Text(
                                                                      "${'Your offer with '.tr()}$offerAmount${" AED has been placed successfully".tr()}"))
                                                              .show(context);
                                                      } else if (offerResponse
                                                              .success ==
                                                          false) {
                                                        if (context.mounted)
                                                          CherryToast.warning(
                                                                  title: Text(
                                                                      "Couldnt add offer"
                                                                          .tr()))
                                                              .show(context);
                                                      }
                                                    } else {
                                                      if (context.mounted)
                                                        CherryToast.warning(
                                                                title: Text(
                                                                    "Please set you offer euqal to Minimum Acceptable Offer or more"
                                                                        .tr()))
                                                            .show(context);
                                                    }
                                                  }
                                                } else {
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                  return;
                                                }
                                              }
                                            }
                                            if (context.mounted) {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            child: Center(
                                              child: Text(
                                                widget.car.auction.endAt
                                                        .isAfter(DateTime.now())
                                                    ? 'Add Bid'.tr()
                                                    : 'Add Offer'.tr(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.car.auction.latestBid != null ? widget.car.auction.latestBid.bid.toString() : widget.car.auction.startPrice.toString()} ${'AED'.tr().replaceAllMapped(
                                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]},',
                                      )}',
                                  style: const TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12),
                                ),
                                Text(
                                  '${widget.car.auction.latestBid != null ? 'Highest bid'.tr() : 'Starting Price'.tr()}',
                                  style: TextStyle(
                                      color: kInactiveTextColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 8),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  Timer startTimer() {
    _remainingDuration = widget.car.auction.endAt.difference(DateTime.now());
    return Timer.periodic(const Duration(seconds: 1), (_) {
      _remainingDuration = widget.car.auction.endAt.difference(DateTime.now());
      setState(() {
        if (_remainingDuration.inSeconds > 1) {
          _remainingDuration =
              widget.car.auction.endAt.difference(DateTime.now());
        }
      });
    });
  }

  subscribeToAuctionSocket() async {
    try {
      Channel channel =
          pusher.subscribe("private-car.auction.${widget.car.auction.id}");
      channel.bind("NewBid", (PusherEvent event) {
        Map eventDecoded = jsonDecode(event.data);
        if (context.mounted) {
          setState(() {
            widget.car.auction = Auction(
              startPrice: widget.car.auction.startPrice,
              id: widget.car.auction.id,
              carId: widget.car.id,
              endAt: DateTime.parse(eventDecoded["auction"]["end_at"]),
              latestBid: LatestBid(
                  auctionId: widget.car.auction.id,
                  bid: eventDecoded["auction"]["last_bid"]),
            );
          });
        }
      });
    } catch (e) {
      if (kDebugMode) {
        log("ERRR: $e");
      }
    }
  }
}
