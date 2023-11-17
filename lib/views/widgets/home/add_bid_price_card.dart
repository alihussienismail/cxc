import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class AddBidPriceCard extends StatefulWidget {
  String currentBidPrice;

  String addedBidPrice;
  AddBidPriceCard({
    Key key,
    this.addedBidPrice,
    this.currentBidPrice,
  }) : super(key: key);

  @override
  State<AddBidPriceCard> createState() => _AddBidPriceCardState();
}

class _AddBidPriceCardState extends State<AddBidPriceCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.currentBidPrice == widget.addedBidPrice ? kSelectedBidCardColor.withOpacity(0.1) : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(side: BorderSide(color: widget.currentBidPrice == widget.addedBidPrice ? kSelectedBidCardColor : kInactiveTextColor, width: 1.0), borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Text(
          '${widget.addedBidPrice}',
          style: TextStyle(color: widget.currentBidPrice == widget.addedBidPrice ? kSelectedBidCardColor : kInactiveTextColor),
        ),
      ),
    );
  }
}
