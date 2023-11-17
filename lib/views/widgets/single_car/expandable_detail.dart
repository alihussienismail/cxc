import 'package:carsxchange/constants/colors.dart';
import 'package:flutter/material.dart';

class ExpandableDetail extends StatefulWidget {
  String title;
  List<Widget> detailsList;

  ExpandableDetail({Key key, @required this.title, @required this.detailsList}) : super(key: key);

  @override
  State<ExpandableDetail> createState() => _ExpandableDetailState();
}

class _ExpandableDetailState extends State<ExpandableDetail> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    widget.detailsList.removeWhere((element) => element == null);
    return widget.detailsList.isEmpty
        ? const SizedBox(height: 0)
        : Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: _isExpanded ? kPrimaryColor : kInactiveTextColor, width: 1.0), borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(fontSize: 16, color: _isExpanded ? kPrimaryColor : kInactiveTextColor),
                          ),
                          Icon(
                            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: _isExpanded ? kPrimaryColor : kInactiveTextColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _isExpanded ? const SizedBox(height: 12) : Container(),
              _isExpanded
                  ? ListView.builder(
                      itemCount: widget.detailsList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return widget.detailsList[index];
                      })
                  : Container(),
            ],
          );
  }
}
