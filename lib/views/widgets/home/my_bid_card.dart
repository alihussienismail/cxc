import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carsxchange/constants/global.dart';
import 'package:carsxchange/models/my_bid.dart';
import 'package:carsxchange/providers/misc_provider.dart';
import 'package:carsxchange/views/widgets/svg_asset.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';

import '../../../constants/colors.dart';

class MyBidCard extends StatefulWidget {
  MyCarBid myCarBid;

  MyBidCard({
    Key key,
    @required this.myCarBid,
  }) : super(key: key);

  @override
  State<MyBidCard> createState() => _MyBidCardState();
}

class _MyBidCardState extends State<MyBidCard> {
  Duration _remainingDuration = const Duration(seconds: 0);
  Timer timer;
  PusherClient pusherClient;

  @override
  void initState() {
    if (widget.myCarBid.auction.endAt.isAfter(DateTime.now())) {
      timer = startTimer();
      subscribeToAuctionSocket();
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.myCarBid.auction.endAt.isAfter(DateTime.now())) {
      timer.cancel();
      pusher.unsubscribe("private-car.auction.${widget.myCarBid.auction.id}");
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
                      imageUrl:
                          getCarImageUrl(widget.myCarBid.car.images.first),
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
                            '${widget.myCarBid.car.details.make} ${widget.myCarBid.car.details.model} ${widget.myCarBid.car.details.year}',
                            maxLines: 2,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const SizedBox(width: 4),
                        !widget.myCarBid.auction.endAt.isAfter(DateTime.now())
                            ? Text(
                                "Expired".tr(),
                                maxLines: 2,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600),
                              )
                            : Text(
                                DateFormat('HH:mm:ss').format(
                                    DateTime(10).add(_remainingDuration)),
                                maxLines: 2,
                                style: const TextStyle(
                                    color: kActiveCardColor,
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
                        Text(
                            '${widget.myCarBid.car.details.mileage} ${' KM'.tr()}',
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
                        Text(widget.myCarBid.car.details.location,
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
                        Text('${widget.myCarBid.car.details.engineSize} CC',
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.myCarBid.bid} ${' AED'.tr()}'
                                      .replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]},',
                                  ),
                                  style: TextStyle(
                                      color: widget.myCarBid.bid >=
                                              widget.myCarBid.auction.latestBid
                                                  .bid
                                          ? kActiveCardColor
                                          : kExpiredCardColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12),
                                ),
                                Text(
                                  'My bid'.tr(),
                                  style: const TextStyle(
                                      color: kInactiveTextColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 8),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${widget.myCarBid.auction.latestBid.bid.toString()} ${' AED'.tr()}'
                                  .replaceAllMapped(
                                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (Match m) => '${m[1]},',
                              ),
                              style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12),
                            ),
                            Text(
                              'Highest bid'.tr(),
                              style: const TextStyle(
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
    _remainingDuration =
        widget.myCarBid.auction.endAt.difference(DateTime.now());
    return Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_remainingDuration.inSeconds > 1) {
          _remainingDuration =
              widget.myCarBid.auction.endAt.difference(DateTime.now());
        } else {
          timer.cancel();
        }
      });
    });
  }

  subscribeToAuctionSocket() async {
    try {
      Channel channel =
          pusher.subscribe("private-car.auction.${widget.myCarBid.auction.id}");
      channel.bind("NewBid", (PusherEvent event) {
        Map eventDecoded = jsonDecode(event.data);
        if (context.mounted) {
          setState(() {
            widget.myCarBid.auction = MyBidAuction(
              latestBid: MyBiddenCarLatestBid(
                  auctionId: widget.myCarBid.auctionId,
                  bid: eventDecoded["auction"]["last_bid"]),
              carId: widget.myCarBid.carId,
              id: widget.myCarBid.auctionId,
              winnerBid: null,
              endAt: DateTime.parse(eventDecoded["auction"]["end_at"]),
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
