import 'dart:convert';
import 'dart:developer';

import 'package:carsxchange/constants/global.dart';
import 'package:carsxchange/models/bid_offer_response_model.dart';
import 'package:carsxchange/models/car_model.dart';
import 'package:carsxchange/models/my_offer.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/my_bid.dart';

class Cars with ChangeNotifier {
  final String _authToken;

  Cars(this._authToken);

  Future<List<Car>> getCarsList(int pageIndex, String filterType) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$BASE_URL/api/v1/cars?page=$pageIndex'),
        headers: {'accept': 'application/json', 'Authorization': _authToken},
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }
      if (response.statusCode == 200) {
        List<Car> carList =
            parseCarsFromJson(jsonDecode(response.body)["data"]);
        if (filterType == "live") {
          carList = carList
              .where((Car car) => car.auction.endAt.isAfter(DateTime.now()))
              .toList();
        } else if (filterType == "expired") {
          carList = carList
              .where((Car car) => car.auction.endAt.isBefore(DateTime.now()))
              .toList();
        } else if (filterType == "custom") {
          carList = carList
              .where((Car car) => car.auction.endAt.isBefore(DateTime.now()))
              .toList();
        }

        return carList;
      } else {
        throw "error";
      }
    } catch (e) {
      if (kDebugMode) {
        log("DEBUG_MESSAGE: Error is:  $e");
      }
      throw "error";
    }
  }

  Future<List<Car>> getCarsListHot(int pageIndex, String filterType) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$BASE_URL/api/v1/cars/hot-deals?page=$pageIndex'),
        headers: {'accept': 'application/json', 'Authorization': _authToken},
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }
      if (response.statusCode == 200) {
        List<Car> carList =
            parseCarsFromJson(jsonDecode(response.body)["data"]);
        if (filterType == "live") {
          carList = carList
              .where((Car car) => car.auction.endAt.isAfter(DateTime.now()))
              .toList();
        } else if (filterType == "expired") {
          carList = carList
              .where((Car car) => car.auction.endAt.isBefore(DateTime.now()))
              .toList();
        } else if (filterType == "custom") {
          carList = carList
              .where((Car car) => car.auction.endAt.isBefore(DateTime.now()))
              .toList();
        }

        return carList;
      } else {
        throw "error";
      }
    } catch (e) {
      if (kDebugMode) {
        log("DEBUG_MESSAGE: Error is:  $e");
      }
      throw "error";
    }
  }

  Future<List<Car>> getCarsListSold(int pageIndex, String filterType) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$BASE_URL/api/v1/cars/sold-deals?page=$pageIndex'),
        headers: {'accept': 'application/json', 'Authorization': _authToken},
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }
      if (response.statusCode == 200) {
        List<Car> carList =
            parseCarsFromJson(jsonDecode(response.body)["data"]);
        if (filterType == "live") {
          carList = carList
              .where((Car car) => car.auction.endAt.isAfter(DateTime.now()))
              .toList();
        } else if (filterType == "expired") {
          carList = carList
              .where((Car car) => car.auction.endAt.isBefore(DateTime.now()))
              .toList();
        } else if (filterType == "sold") {
          carList = carList
              .where((Car car) => car.auction.endAt.isBefore(DateTime.now()))
              .toList();
        }

        return carList;
      } else {
        throw "error";
      }
    } catch (e) {
      if (kDebugMode) {
        log("DEBUG_MESSAGE: Error is:  $e");
      }
      throw "error";
    }
  }

  // will return ALL expired cars on the website.
  // Future<List<Car>> getExpiredCarsList(int pageKey) async {
  //   try {
  //     http.Response response = await http.get(
  //       Uri.parse('$BASE_URL/api/v1/cars/expired-auction?page=$pageKey'),
  //       headers: {'accept': 'application/json', 'Authorization': _authToken},
  //     );
  //     if (kDebugMode) {
  //       log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
  //       log("DEBUG_MESSAGE: response is:  ${response.body}");
  //     }
  //     if (response.statusCode == 200) {
  //       List<Car> carList = parseCarsFromJson(jsonDecode(response.body)["data"]);
  //
  //       return carList;
  //     } else {
  //       throw "error";
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       log("DEBUG_MESSAGE: Error is:  $e");
  //     }
  //     throw "error";
  //   }
  // }

  Future<DetailedCarInfo> getCarDetails(int carId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$BASE_URL/api/v1/dealer/cars/$carId'),
        headers: {'accept': 'application/json', 'Authorization': _authToken},
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }
      if (response.statusCode == 200) {
        DetailedCarInfo detailedCarInfo =
            detailedCarInfoFromJson(response.body);
        return detailedCarInfo;
      } else {
        throw "error";
      }
    } catch (e, stack) {
      if (kDebugMode) {
        log("DEBUG_MESSAGE: Error is:  $e, and stack is $stack");
      }
      return null;
    }
  }

  Future<BidResponse> addCarBid(int carId, int auctionId, int bidAmount) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$BASE_URL/api/v1/dealer/bid'),
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': _authToken
        },
        body: jsonEncode(
            {"car_id": carId, "auction_id": auctionId, "bid": bidAmount}),
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }

      return bidResponseFromJson(response.body);
    } catch (e) {
      if (kDebugMode) {
        log("DEBUG_MESSAGE: Error is:  $e");
      }
      return null;
    }
  }

  Future<OfferResponse> addCarOffer(int carId, int offerAmount) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$BASE_URL/api/v1/dealer/offer'),
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': _authToken
        },
        body: jsonEncode({"car_id": carId, "amount": offerAmount}),
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }

      return offerResponseFromJson(response.body);
    } catch (e) {
      if (kDebugMode) {
        log("DEBUG_MESSAGE: Error is:  $e");
      }
      return null;
    }
  }

  Future<List<MyCarBid>> getMyCarBids() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$BASE_URL/api/v1/profile/bids'),
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': _authToken
        },
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }

      if (response.statusCode == 200) {
        List<MyCarBid> myCarBids = myCarBidsFromJson(response.body);
        return myCarBids;
      } else {
        throw "error";
      }
    } catch (e, stack) {
      if (kDebugMode) {
        log("DEBUG_MESSAGE: Error is:  $e, and stack is $stack");
      }
      return null;
    }
  }

  Future<List<MyCarOffer>> getMyCarOffers() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$BASE_URL/api/v1/profile/offers'),
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'Authorization': _authToken
        },
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }

      if (response.statusCode == 200) {
        List<MyCarOffer> myCarOffers = myCarOfferFromJson(response.body);
        return myCarOffers;
      } else {
        throw "error";
      }
    } catch (e, stack) {
      if (kDebugMode) {
        log("DEBUG_MESSAGE: Error is:  $e, and stack is $stack");
      }
      return null;
    }
  }
}
