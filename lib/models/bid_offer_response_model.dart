// To parse this JSON data, do
//
//     final bidResponse = bidResponseFromJson(jsonString);

import 'dart:convert';

BidResponse bidResponseFromJson(String str) => BidResponse.fromJson(json.decode(str));

class BidResponse {
  bool success;
  int lastBid;
  int nextMinBid;
  DateTime endAt;
  String message;

  BidResponse({
    this.success,
    this.lastBid,
    this.nextMinBid,
    this.endAt,
    this.message,
  });

  factory BidResponse.fromJson(Map<String, dynamic> json) => BidResponse(
        success: json["success"],
        lastBid: json["last_bid"],
        nextMinBid: json["next_min_bid"],
        endAt: DateTime.parse(json["end_at"]),
        message: json["message"],
      );
}

OfferResponse offerResponseFromJson(String str) => OfferResponse.fromJson(json.decode(str));

class OfferResponse {
  bool success;
  Offer offer;

  OfferResponse({
    this.success,
    this.offer,
  });

  factory OfferResponse.fromJson(Map<String, dynamic> json) => OfferResponse(
        success: json["success"],
        offer: Offer.fromJson(json["offer"]),
      );
}

class Offer {
  int userId;
  int carId;
  int amount;
  DateTime createdAt;
  int id;

  Offer({
    this.userId,
    this.carId,
    this.amount,
    this.createdAt,
    this.id,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        userId: json["user_id"],
        carId: json["car_id"],
        amount: json["amount"],
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );
}
