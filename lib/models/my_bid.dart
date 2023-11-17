import 'dart:convert';

List<MyCarBid> myCarBidsFromJson(String str) => List<MyCarBid>.from(json.decode(str).map((x) => MyCarBid.fromJson(x)));

class MyCarBid {
  int id;
  int carId;
  int userId;
  int auctionId;
  int bid;
  DateTime createdAt;
  MyBiddenCar car;
  MyBidAuction auction;

  MyCarBid({
    this.id,
    this.carId,
    this.userId,
    this.auctionId,
    this.bid,
    this.createdAt,
    this.car,
    this.auction,
  });

  factory MyCarBid.fromJson(Map<String, dynamic> json) => MyCarBid(
        id: json["id"],
        carId: json["car_id"],
        userId: json["user_id"],
        auctionId: json["auction_id"],
        bid: json["bid"],
        createdAt: DateTime.parse(json["created_at"]),
        car: MyBiddenCar.fromJson(json["car"]),
        auction: MyBidAuction.fromJson(json["auction"]),
      );
}

class MyBidAuction {
  int id;
  int carId;
  DateTime endAt;
  dynamic winnerBid;
  MyBiddenCarLatestBid latestBid;

  MyBidAuction({
    this.id,
    this.carId,
    this.endAt,
    this.winnerBid,
    this.latestBid,
  });

  factory MyBidAuction.fromJson(Map<String, dynamic> json) => MyBidAuction(
        id: json["id"],
        carId: json["car_id"],
        endAt: DateTime.parse(json["end_at"]),
        winnerBid: json["winner_bid"],
        latestBid: MyBiddenCarLatestBid.fromJson(json["latest_bid"]),
      );
}

class MyBiddenCarLatestBid {
  int auctionId;
  int bid;

  MyBiddenCarLatestBid({
    this.auctionId,
    this.bid,
  });

  factory MyBiddenCarLatestBid.fromJson(Map<String, dynamic> json) => MyBiddenCarLatestBid(
        auctionId: json["auction_id"],
        bid: json["bid"],
      );
}

class MyBiddenCar {
  int id;
  List<String> images;
  String status;
  DateTime createdAt;
  MyBiddenCarDetails details;

  MyBiddenCar({
    this.id,
    this.images,
    this.status,
    this.createdAt,
    this.details,
  });

  factory MyBiddenCar.fromJson(Map<String, dynamic> json) => MyBiddenCar(
        id: json["id"],
        images: List<String>.from(json["images"].map((x) => x)),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        details: MyBiddenCarDetails.fromJson(json["details"]),
      );
}

class MyBiddenCarDetails {
  String make;
  String model;
  int year;
  int mileage;
  dynamic engineSize;
  String location;

  MyBiddenCarDetails({
    this.make,
    this.model,
    this.year,
    this.mileage,
    this.engineSize,
    this.location,
  });

  factory MyBiddenCarDetails.fromJson(Map<String, dynamic> json) => MyBiddenCarDetails(
        make: json["make"],
        model: json["model"],
        year: json["year"],
        mileage: json["mileage"],
        engineSize: json["engine_size"],
        location: json["registered_emirates"],
      );
}
