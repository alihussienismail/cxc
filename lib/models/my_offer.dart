import 'dart:convert';

List<MyCarOffer> myCarOfferFromJson(String str) => List<MyCarOffer>.from(json.decode(str).map((x) => MyCarOffer.fromJson(x)));

class MyCarOffer {
  int id;
  int carId;
  int userId;
  int amount;
  DateTime createdAt;
  MyOfferedCar car;

  MyCarOffer({
    this.id,
    this.carId,
    this.userId,
    this.amount,
    this.createdAt,
    this.car,
  });

  factory MyCarOffer.fromJson(Map<String, dynamic> json) => MyCarOffer(
        id: json["id"],
        carId: json["car_id"],
        userId: json["user_id"],
        amount: json["amount"],
        createdAt: DateTime.parse(json["created_at"]),
        car: MyOfferedCar.fromJson(json["car"]),
      );
}

class MyOfferedCar {
  int id;
  List<String> images;
  String status;
  DateTime createdAt;
  MyOfferedCarDetails details;

  MyOfferedCar({
    this.id,
    this.images,
    this.status,
    this.createdAt,
    this.details,
  });

  factory MyOfferedCar.fromJson(Map<String, dynamic> json) => MyOfferedCar(
        id: json["id"],
        images: List<String>.from(json["images"].map((x) => x)),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        details: MyOfferedCarDetails.fromJson(json["details"]),
      );
}

class MyOfferedCarDetails {
  String make;
  String model;
  int year;
  int mileage;
  dynamic engineSize;
  String location;

  MyOfferedCarDetails({
    this.make,
    this.model,
    this.year,
    this.mileage,
    this.engineSize,
    this.location,
  });

  factory MyOfferedCarDetails.fromJson(Map<String, dynamic> json) => MyOfferedCarDetails(
        make: json["make"],
        model: json["model"],
        year: json["year"],
        mileage: json["mileage"],
        engineSize: json["engine_size"],
        location: json["registered_emirates"],
      );
}
