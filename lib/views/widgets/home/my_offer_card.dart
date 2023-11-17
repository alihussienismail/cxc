import 'package:cached_network_image/cached_network_image.dart';
import 'package:carsxchange/models/my_offer.dart';
import 'package:carsxchange/providers/misc_provider.dart';
import 'package:carsxchange/views/widgets/svg_asset.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class MyOffersCard extends StatefulWidget {
  MyCarOffer myCarOffer;

  MyOffersCard({
    Key key,
    @required this.myCarOffer,
  }) : super(key: key);

  @override
  State<MyOffersCard> createState() => _MyOffersCardState();
}

class _MyOffersCardState extends State<MyOffersCard> {
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
                          getCarImageUrl(widget.myCarOffer.car.images.first),
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
                            '${widget.myCarOffer.car.details.make} ${widget.myCarOffer.car.details.model} ${widget.myCarOffer.car.details.year}',
                            maxLines: 2,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const SizedBox(width: 4),
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
                            '${widget.myCarOffer.car.details.mileage} ${' Km'.tr()}',
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
                        Text(widget.myCarOffer.car.details.location,
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
                        Text('${widget.myCarOffer.car.details.engineSize} CC',
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.myCarOffer.amount} ${' AED'.tr()}'
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
                                  'My Offer'.tr(),
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
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
