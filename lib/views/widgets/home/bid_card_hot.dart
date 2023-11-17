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

class BidCardHot extends StatefulWidget {
  Car car;

  BidCardHot({
    Key key,
    @required this.car,
  }) : super(key: key);

  @override
  State<BidCardHot> createState() => _BidCardHotState();
}

class _BidCardHotState extends State<BidCardHot> {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 64,
                width: 106,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
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
                        Text('${widget.car.details.engineSize} ${'CC'.tr()}',
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${widget.car.auction.latestBid != null ? widget.car.details.sellerPrice.toString() : widget.car.details.sellerPrice.toString()} ${'AED'.tr().replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]},',
                                  )}',
                              style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12),
                            ),
                            Text(
                              'Seller price'.tr(),
                              style: TextStyle(
                                  color: kInactiveTextColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8),
                            ),
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
                              'Highest Bid'.tr(),
                              style: TextStyle(
                                  color: kInactiveTextColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8),
                            )
                          ],
                        )
                      ],
                    ),
                    // const Divider(
                    //   height: 17,
                    //   color: kInactiveTextColor,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Column(
                    //       mainAxisAlignment: MainAxisAlignment.end,
                    //       crossAxisAlignment: CrossAxisAlignment.end,
                    //       children: [
                    //         Text(
                    //           '${widget.car.auction.latestBid != null ? widget.car.auction.latestBid.bid.toString() : widget.car.auction.startPrice.toString()} ${'AED'.tr().replaceAllMapped(
                    //                 RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    //                 (Match m) => '${m[1]},',
                    //               )}',
                    //           style: const TextStyle(
                    //               color: kPrimaryColor,
                    //               fontWeight: FontWeight.w800,
                    //               fontSize: 12),
                    //         ),
                    //         Text(
                    //           'Highest Bid'.tr(),
                    //           style: TextStyle(
                    //               color: kInactiveTextColor,
                    //               fontWeight: FontWeight.w400,
                    //               fontSize: 8),
                    //         )
                    //       ],
                    //     )
                    //   ],
                    // ),
                    const Divider(
                      height: 16,
                      color: kInactiveTextColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${widget.car.auction.latestBid != null ? widget.car.minimumoffer.toString() : widget.car.minimumoffer.toString()} ${'AED'.tr().replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]},',
                                  )}',
                              style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12),
                            ),
                            Text(
                              'Minimum offer'.tr(),
                              style: TextStyle(
                                  color: kInactiveTextColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
