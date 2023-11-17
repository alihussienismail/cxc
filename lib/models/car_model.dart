import 'dart:convert';
import 'dart:ffi';

List<Car> parseCarsFromJson(List carsList) =>
    List<Car>.from(carsList.map((x) => Car.fromJson(x)));

class Car {
  int id;
  List<String> images;
  String status;
  DateTime createdAt;
  Details details;
  Auction auction;
  int minimumoffer;
  bool _isFirstLive = false;

  bool get isFirstLive => _isFirstLive;

  set isFirstLive(bool value) {
    _isFirstLive = value;
  }

  bool _isFirstExpired = false;

  bool get isFirstExpired => _isFirstExpired;

  set isFirstExpired(bool value) {
    _isFirstExpired = value;
  }

  Car(
      {this.id,
      this.images,
      this.status,
      this.createdAt,
      this.details,
      this.auction,
      this.minimumoffer});

  factory Car.fromJson(Map<String, dynamic> json) => Car(
      id: json["id"],
      images: List<String>.from(json["images"].map((x) => x)),
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      details: Details.fromJson(json["details"]),
      auction: Auction.fromJson(json["auction"]),
      minimumoffer: json["minimum_offer_amount"]);
}

class Auction {
  int id;
  int carId;
  DateTime endAt;
  int startPrice;
  LatestBid latestBid;

  Auction({
    this.id,
    this.carId,
    this.endAt,
    this.startPrice,
    this.latestBid,
  });

  factory Auction.fromJson(Map<String, dynamic> json) => Auction(
        id: json["id"],
        carId: json["car_id"],
        endAt: DateTime.parse(json["end_at"]),
        startPrice: json["start_price"],
        latestBid: json["latest_bid"] == null
            ? null
            : LatestBid.fromJson(json["latest_bid"]),
      );
}

class LatestBid {
  int auctionId;
  int bid;

  LatestBid({
    this.auctionId,
    this.bid,
  });

  factory LatestBid.fromJson(Map<String, dynamic> json) => LatestBid(
        auctionId: json["auction_id"],
        bid: json["bid"],
      );
}

class Details {
  String make;
  String model;
  String trim;
  int year;
  int mileage;
  int sellerPrice;

  String exteriorColor;
  String engineSize;
  String specification;
  String location;

  Details({
    this.make,
    this.model,
    this.trim,
    this.year,
    this.mileage,
    this.exteriorColor,
    this.engineSize,
    this.specification,
    this.location,
    this.sellerPrice,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        make: json["make"],
        model: json["model"],
        trim: json["trim"],
        year: json["year"],
        mileage: json["mileage"],
        exteriorColor: json["exterior_color"],
        engineSize: json["engine_size"],
        specification: json["specification"],
        location: json["registered_emirates"],
        sellerPrice: json["seller_price"],
      );
}

DetailedCarInfo detailedCarInfoFromJson(String str) =>
    DetailedCarInfo.fromJson(json.decode(str));

String detailedCarInfoToJson(DetailedCarInfo data) =>
    json.encode(data.toJson());

class DetailedCarInfo {
  DetailedCar car;
  MyBid myBid;
  MyOffer myOffer;

  DetailedCarInfo({
    this.car,
    this.myBid,
    this.myOffer,
  });

  factory DetailedCarInfo.fromJson(Map<String, dynamic> json) =>
      DetailedCarInfo(
        car: DetailedCar.fromJson(json["car"]),
        myBid: json["my_bid"] == null ? null : MyBid.fromJson(json["my_bid"]),
        myOffer: json["my_offer"] == null
            ? null
            : MyOffer.fromJson(json["my_offer"]),
      );

  Map<String, dynamic> toJson() => {
        "car": car.toJson(),
        "my_bid": myBid.toJson(),
        "my_offer": myOffer.toJson(),
      };
}

class DetailedCar {
  int id;
  List<String> images;
  String status;
  DateTime createdAt;
  DetailedCarDetails details;
  History history;
  EngineTransmission engineTransmission;
  Steering steering;
  Interior interior;
  Exterior exterior;
  Specs specs;
  Wheels wheels;
  DetailedCarAuction auction;
  int minimumoffer;

  DetailedCar(
      {this.id,
      this.images,
      this.status,
      this.createdAt,
      this.details,
      this.history,
      this.engineTransmission,
      this.steering,
      this.interior,
      this.exterior,
      this.specs,
      this.wheels,
      this.auction,
      this.minimumoffer});

  factory DetailedCar.fromJson(Map<String, dynamic> json) => DetailedCar(
        id: json["id"],
        images: List<String>.from(json["images"].map((x) => x)),
        status: json["status"],
        minimumoffer: json["minimum_offer_amount"],
        createdAt: DateTime.parse(json["created_at"]),
        details: DetailedCarDetails.fromJson(json["details"]),
        history: History.fromJson(json["history"]),
        engineTransmission:
            EngineTransmission.fromJson(json["engine_transmission"]),
        steering: Steering.fromJson(json["steering"]),
        interior: Interior.fromJson(json["interior"]),
        exterior: Exterior.fromJson(json["exterior"]),
        specs: Specs.fromJson(json["specs"]),
        wheels: Wheels.fromJson(json["wheels"]),
        auction: DetailedCarAuction.fromJson(json["auction"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x)),
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "details": details.toJson(),
        "history": history.toJson(),
        "engine_transmission": engineTransmission.toJson(),
        "steering": steering.toJson(),
        "interior": interior.toJson(),
        "exterior": exterior.toJson(),
        "specs": specs.toJson(),
        "wheels": wheels.toJson(),
        "auction": auction.toJson(),
      };
}

class DetailedCarAuction {
  int id;
  int carId;
  DateTime startAt;
  DateTime endAt;
  int startPrice;
  DetailedCarLatestBid latestBid;

  DetailedCarAuction({
    this.id,
    this.carId,
    this.startAt,
    this.endAt,
    this.startPrice,
    this.latestBid,
  });

  factory DetailedCarAuction.fromJson(Map<String, dynamic> json) =>
      DetailedCarAuction(
        id: json["id"],
        carId: json["car_id"],
        startAt: DateTime.parse(json["start_at"]),
        endAt: DateTime.parse(json["end_at"]),
        startPrice: json["start_price"],
        latestBid: json["latest_bid"] == null
            ? null
            : DetailedCarLatestBid.fromJson(json["latest_bid"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "car_id": carId,
        "start_at": startAt.toIso8601String(),
        "end_at": endAt.toIso8601String(),
        "start_price": startPrice,
        "latest_bid": latestBid.toJson(),
      };
}

class DetailedCarLatestBid {
  int auctionId;
  int bid;

  DetailedCarLatestBid({
    this.auctionId,
    this.bid,
  });

  factory DetailedCarLatestBid.fromJson(Map<String, dynamic> json) =>
      DetailedCarLatestBid(
        auctionId: json["auction_id"],
        bid: json["bid"],
      );

  Map<String, dynamic> toJson() => {
        "auction_id": auctionId,
        "bid": bid,
      };
}

class DetailedCarDetails {
  String make;
  String model;
  String trim;
  int year;
  int mileage;
  String location;
  String interiorType;
  String bodyType;
  String specification;
  String exteriorColor;
  String interiorColor;
  String keys;
  String firstOwner;
  int sellerPrice;
  String engineSize;
  int numberOfCylinders;
  String fuelType;
  String transmission;
  String wheelType;
  String carOptions;
  String safetyBelt;

  DetailedCarDetails({
    this.make,
    this.model,
    this.trim,
    this.year,
    this.mileage,
    this.location,
    this.interiorType,
    this.bodyType,
    this.specification,
    this.exteriorColor,
    this.interiorColor,
    this.keys,
    this.firstOwner,
    this.sellerPrice,
    this.engineSize,
    this.numberOfCylinders,
    this.fuelType,
    this.transmission,
    this.wheelType,
    this.carOptions,
    this.safetyBelt,
  });

  factory DetailedCarDetails.fromJson(Map<String, dynamic> json) =>
      DetailedCarDetails(
        make: json["make"],
        model: json["model"],
        trim: json["trim"],
        year: json["year"],
        mileage: json["mileage"],
        location: json["registered_emirates"],
        interiorType: json["interior_type"],
        bodyType: json["body_type"],
        specification: json["specification"],
        exteriorColor: json["exterior_color"],
        interiorColor: json["interior_color"],
        keys: json["keys"],
        firstOwner: json["first_owner"],
        sellerPrice: json["seller_price"],
        engineSize: json["engine_size"],
        numberOfCylinders: json["number_of_cylinders"],
        fuelType: json["fuel_type"],
        transmission: json["transmission"],
        wheelType: json["wheel_type"],
        carOptions: json["car_options"],
        safetyBelt: json["safety_belt"],
      );

  Map<String, dynamic> toJson() => {
        "make": make,
        "model": model,
        "trim": trim,
        "year": year,
        "mileage": mileage,
        "registered_emirates": location,
        "interior_type": interiorType,
        "body_type": bodyType,
        "specification": specification,
        "exterior_color": exteriorColor,
        "interior_color": interiorColor,
        "keys": keys,
        "first_owner": firstOwner,
        "seller_price": sellerPrice,
        "engine_size": engineSize,
        "number_of_cylinders": numberOfCylinders,
        "fuel_type": fuelType,
        "transmission": transmission,
        "wheel_type": wheelType,
        "car_options": carOptions,
        "safety_belt": safetyBelt,
      };
}

class EngineTransmission {
  String radiatorCondition;
  String radiatorFan;
  String engineNoise;
  String axles;
  String coolant;
  String engineIdling;
  String engineSmoke;
  String transmissionCondition;
  String silencer;
  dynamic engineComment;
  String airbag;
  String chassis;
  String chassisExtension;
  int warningSignal;
  String oilLeaks;
  String shiftInterlockCondition;
  String engineGroup;
  String hosesAndPipesCondition;

  EngineTransmission({
    this.radiatorCondition,
    this.radiatorFan,
    this.engineNoise,
    this.axles,
    this.coolant,
    this.engineIdling,
    this.engineSmoke,
    this.transmissionCondition,
    this.silencer,
    this.engineComment,
    this.airbag,
    this.chassis,
    this.chassisExtension,
    this.warningSignal,
    this.oilLeaks,
    this.shiftInterlockCondition,
    this.engineGroup,
    this.hosesAndPipesCondition,
  });

  factory EngineTransmission.fromJson(Map<String, dynamic> json) =>
      EngineTransmission(
        radiatorCondition: json["Radiator_Condition"],
        radiatorFan: json["Radiator_Fan"],
        engineNoise: json["Engine_Noise"],
        axles: json["Axels"],
        coolant: json["Coolant"],
        engineIdling: json["Engine_Idling"],
        engineSmoke: json["Engine_Smoke"],
        transmissionCondition: json["Transmission_Condition"],
        silencer: json["Silencer"],
        engineComment: json["Engine_Comment"],
        airbag: json["Airbag"],
        chassis: json["Chassis"],
        chassisExtension: json["Chassis_Extension"],
        warningSignal: json["Warning_Signal"],
        oilLeaks: json["Oil_Leaks"],
        shiftInterlockCondition: json["Shift_Interlock_Condition"],
        engineGroup: json["Engine_Group"],
        hosesAndPipesCondition: json["Hoses_and_Pipes_Condition"],
      );

  Map<String, dynamic> toJson() => {
        "Radiator_Condition": radiatorCondition,
        "Radiator_Fan": radiatorFan,
        "Engine_Noise": engineNoise,
        "Axels": axles,
        "Coolant": coolant,
        "Engine_Idling": engineIdling,
        "Engine_Smoke": engineSmoke,
        "Transmission_Condition": transmissionCondition,
        "Silencer": silencer,
        "Engine_Comment": engineComment,
        "Airbag": airbag,
        "Chassis": chassis,
        "Chassis_Extension": chassisExtension,
        "Warning_Signal": warningSignal,
        "Oil_Leaks": oilLeaks,
        "Shift_Interlock_Condition": shiftInterlockCondition,
        "Engine_Group": engineGroup,
        "Hoses_and_Pipes_Condition": hosesAndPipesCondition,
      };
}

class Exterior {
  Markers markers;
  String exteriorComment;

  Exterior({
    this.markers,
    this.exteriorComment,
  });

  factory Exterior.fromJson(Map<String, dynamic> json) => Exterior(
        markers: json["markers"] == null || json["markers"].isEmpty
            ? Markers()
            : Markers.fromJson(json["markers"]),
        exteriorComment: json["exterior_comment"],
      );

  Map<String, dynamic> toJson() => {
        "markers": markers.toJson(),
        "exterior_comment": exteriorComment,
      };
}

class Markers {
  String top;
  String hood;
  String trunkLid;
  String backBumper;
  String frontBumper;
  String leftBackPanel;
  String leftFrontDoor;
  String rightBackDoor;
  String leftBackDoor;
  String leftBackBumper;
  String leftFrontPanel;
  String rightBackPanel;
  String rightFrontDoor;
  String leftFrontBumper;
  String rightBackBumper;
  String rightFrontPanel;
  String rightFrontBumper;

  Markers({
    this.hood,
    this.top,
    this.trunkLid,
    this.backBumper,
    this.frontBumper,
    this.leftBackPanel,
    this.leftFrontDoor,
    this.rightBackDoor,
    this.leftBackDoor,
    this.leftBackBumper,
    this.leftFrontPanel,
    this.rightBackPanel,
    this.rightFrontDoor,
    this.leftFrontBumper,
    this.rightBackBumper,
    this.rightFrontPanel,
    this.rightFrontBumper,
  });

  factory Markers.fromJson(Map<String, dynamic> json) => Markers(
        top: json["top"],
        hood: json["hood"],
        trunkLid: json["trunkLid"],
        backBumper: json["backBumper"],
        frontBumper: json["frontBumper"],
        leftBackPanel: json["leftBackPanel"],
        leftFrontDoor: json["leftFrontDoor"],
        rightBackDoor: json["rightBackDoor"],
        leftBackDoor: json["leftBackDoor"],
        leftBackBumper: json["leftBackBumper"],
        leftFrontPanel: json["leftFrontPanel"],
        rightBackPanel: json["rightBackPanel"],
        rightFrontDoor: json["rightFrontDoor"],
        leftFrontBumper: json["leftFrontBumper"],
        rightBackBumper: json["rightBackBumper"],
        rightFrontPanel: json["rightFrontPanel"],
        rightFrontBumper: json["rightFrontBumper"],
      );

  Map<String, String> toJson() => {
        "top": top,
        "hood": hood,
        "trunkLid": trunkLid,
        "backBumper": backBumper,
        "frontBumper": frontBumper,
        "leftBackPanel": leftBackPanel,
        "leftFrontDoor": leftFrontDoor,
        "rightBackDoor": rightBackDoor,
        "leftBackDoor": leftBackDoor,
        "leftBackBumper": leftBackBumper,
        "leftFrontPanel": leftFrontPanel,
        "rightBackPanel": rightBackPanel,
        "rightFrontDoor": rightFrontDoor,
        "leftFrontBumper": leftFrontBumper,
        "rightBackBumper": rightBackBumper,
        "rightFrontPanel": rightFrontPanel,
        "rightFrontBumper": rightFrontBumper,
      };
}

class History {
  String serviceHistory;
  String manuals;
  String warranty;
  String accidentHistory;
  String bankFinance;
  String carHistoryComment;
  String bankFinanceStatus;

  History({
    this.serviceHistory,
    this.manuals,
    this.warranty,
    this.accidentHistory,
    this.bankFinance,
    this.carHistoryComment,
    this.bankFinanceStatus,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        serviceHistory: json["service_history"],
        manuals: json["manuals"],
        warranty: json["warranty"],
        accidentHistory: json["accident_history"].toString(),
        bankFinance: json["bank_finance"],
        carHistoryComment: json["car_history_comment"],
        bankFinanceStatus: json["bank_finance_status"],
      );

  Map<String, dynamic> toJson() => {
        "service_history": serviceHistory,
        "manuals": manuals,
        "warranty": warranty,
        "accident_history": accidentHistory,
        "bank_finance": bankFinance,
        "car_history_comment": carHistoryComment,
        "bank_finance_status": bankFinanceStatus,
      };
}

class Interior {
  String dashboardCondition;
  String steeringMountedControls;
  String centerConsoleBox;
  String speedometerCluster;
  String doorTrimPanels;
  String headliner;
  String seatControls;
  String bootTrunkArea;
  String centralLockOperation;
  String musicMultimediaSystem;
  String navigationControl;
  String headlights;
  String tailLights;
  String sunroofCondition;
  String windowsControlsCondition;
  String cruiseControl;
  String pushStopButton;
  String acCooling;
  String convertibleOperations;
  String acHeating;
  dynamic interiorComment;

  Interior({
    this.dashboardCondition,
    this.steeringMountedControls,
    this.centerConsoleBox,
    this.speedometerCluster,
    this.doorTrimPanels,
    this.headliner,
    this.seatControls,
    this.bootTrunkArea,
    this.centralLockOperation,
    this.musicMultimediaSystem,
    this.navigationControl,
    this.headlights,
    this.tailLights,
    this.sunroofCondition,
    this.windowsControlsCondition,
    this.cruiseControl,
    this.pushStopButton,
    this.acCooling,
    this.convertibleOperations,
    this.acHeating,
    this.interiorComment,
  });

  factory Interior.fromJson(Map<String, dynamic> json) => Interior(
        dashboardCondition: json["Dashboard_Condition"],
        steeringMountedControls: json["Steering_Mounted_Controls"],
        centerConsoleBox: json["Center_Console_Box"],
        speedometerCluster: json["Speedometer_Cluster"],
        doorTrimPanels: json["Door_Trim_Panels"],
        headliner: json["Headliner"],
        seatControls: json["Seat_Controls"],
        bootTrunkArea: json["Boot_Trunk_Area"],
        centralLockOperation: json["Central_Lock_Operation"],
        musicMultimediaSystem: json["Music_Multimedia_System"],
        navigationControl: json["Navigation_Control"],
        headlights: json["Headlights"],
        tailLights: json["Tail_Lights"],
        sunroofCondition: json["Sunroof_Condition"],
        windowsControlsCondition: json["Windows_Controls_Condition"],
        cruiseControl: json["Cruise_Control"],
        pushStopButton: json["Push_Stop_Button"],
        acCooling: json["AC_Cooling"],
        convertibleOperations: json["Convertible_Operations"],
        acHeating: json["AC_Heating"],
        interiorComment: json["Interior_Comment"],
      );

  Map<String, dynamic> toJson() => {
        "Dashboard_Condition": dashboardCondition,
        "Steering_Mounted_Controls": steeringMountedControls,
        "Center_Console_Box": centerConsoleBox,
        "Speedometer_Cluster": speedometerCluster,
        "Door_Trim_Panels": doorTrimPanels,
        "Headliner": headliner,
        "Seat_Controls": seatControls,
        "Boot_Trunk_Area": bootTrunkArea,
        "Central_Lock_Operation": centralLockOperation,
        "Music_Multimedia_System": musicMultimediaSystem,
        "Navigation_Control": navigationControl,
        "Headlights": headlights,
        "Tail_Lights": tailLights,
        "Sunroof_Condition": sunroofCondition,
        "Windows_Controls_Condition": windowsControlsCondition,
        "Cruise_Control": cruiseControl,
        "Push_Stop_Button": pushStopButton,
        "AC_Cooling": acCooling,
        "Convertible_Operations": convertibleOperations,
        "AC_Heating": acHeating,
        "Interior_Comment": interiorComment,
      };
}

class Specs {
  dynamic fogLights;
  dynamic parkingSensor;
  dynamic winch;
  dynamic roofRack;
  dynamic spoiler;
  dynamic dualExhaust;
  dynamic alarm;
  dynamic rearVideo;
  dynamic premiumSound;
  dynamic headsUpDisplay;
  dynamic auxAudio;
  dynamic bluetooth;
  dynamic climateControl;
  dynamic keylessEntry;
  dynamic keylessStart;
  dynamic leatherSeats;
  dynamic racingSeats;
  dynamic cooledSeats;
  dynamic heatedSeats;
  dynamic powerSeats;
  dynamic powerLocks;
  dynamic powerMirrors;
  dynamic powerWindows;
  dynamic memorySeats;
  dynamic viewCamera;
  dynamic blindSpotIndicator;
  dynamic antiLock;
  dynamic adaptiveCruiseControl;
  dynamic powerSteering;
  dynamic nightVision;
  dynamic liftKit;
  dynamic parkAssist;
  dynamic adaptiveSuspension;
  dynamic heightControl;
  dynamic navigationSystem;
  String drives;
  String sunroofType;
  dynamic n29System;
  dynamic sideSteps;
  String convertible;
  dynamic otherFeatures;
  dynamic carbonFiberInterior;
  dynamic lineChangeAssist;

  Specs({
    this.fogLights,
    this.parkingSensor,
    this.winch,
    this.roofRack,
    this.spoiler,
    this.dualExhaust,
    this.alarm,
    this.rearVideo,
    this.premiumSound,
    this.headsUpDisplay,
    this.auxAudio,
    this.bluetooth,
    this.climateControl,
    this.keylessEntry,
    this.keylessStart,
    this.leatherSeats,
    this.racingSeats,
    this.cooledSeats,
    this.heatedSeats,
    this.powerSeats,
    this.powerLocks,
    this.powerMirrors,
    this.powerWindows,
    this.memorySeats,
    this.viewCamera,
    this.blindSpotIndicator,
    this.antiLock,
    this.adaptiveCruiseControl,
    this.powerSteering,
    this.nightVision,
    this.liftKit,
    this.parkAssist,
    this.adaptiveSuspension,
    this.heightControl,
    this.navigationSystem,
    this.drives,
    this.sunroofType,
    this.n29System,
    this.sideSteps,
    this.convertible,
    this.otherFeatures,
    this.carbonFiberInterior,
    this.lineChangeAssist,
  });

  factory Specs.fromJson(Map<String, dynamic> json) => Specs(
        fogLights: json["Fog_Lights"],
        parkingSensor: json["Parking_Sensor"],
        winch: json["Winch"],
        roofRack: json["Roof_Rack"],
        spoiler: json["Spoiler"],
        dualExhaust: json["Dual_Exhaust"],
        alarm: json["Alarm"],
        rearVideo: json["Rear_Video"],
        premiumSound: json["Premium_Sound"],
        headsUpDisplay: json["Heads_Up_Display"],
        auxAudio: json["Aux_Audio"],
        bluetooth: json["Bluetooth"],
        climateControl: json["Climate_Control"],
        keylessEntry: json["Keyless_Entry"],
        keylessStart: json["Keyless_Start"],
        leatherSeats: json["Leather_Seats"],
        racingSeats: json["Racing_Seats"],
        cooledSeats: json["Cooled_Seats"],
        heatedSeats: json["Heated_Seats"],
        powerSeats: json["Power_Seats"],
        powerLocks: json["Power_Locks"],
        powerMirrors: json["Power_Mirrors"],
        powerWindows: json["Power_Windows"],
        memorySeats: json["Memory_Seats"],
        viewCamera: json["View_Camera"],
        blindSpotIndicator: json["Blind_Spot_Indicator"],
        antiLock: json["Anti_Lock"],
        adaptiveCruiseControl: json["Adaptive_Cruise_Control"],
        powerSteering: json["Power_Steering"],
        nightVision: json["Night_Vision"],
        liftKit: json["Lift_Kit"],
        parkAssist: json["Park_Assist"],
        adaptiveSuspension: json["Adaptive_Suspension"],
        heightControl: json["Height_Control"],
        navigationSystem: json["Navigation_System"],
        drives: json["Drives"],
        sunroofType: json["Sunroof_Type"],
        n29System: json["N29_System"],
        sideSteps: json["Side_Steps"],
        convertible: json["Convertible"],
        otherFeatures: json["Other_Features"],
        carbonFiberInterior: json["Carbon_Fiber_Interior"],
        lineChangeAssist: json["Line_Change_Assist"],
      );

  Map<String, dynamic> toJson() => {
        "Fog_Lights": fogLights,
        "Parking_Sensor": parkingSensor,
        "Winch": winch,
        "Roof_Rack": roofRack,
        "Spoiler": spoiler,
        "Dual_Exhaust": dualExhaust,
        "Alarm": alarm,
        "Rear_Video": rearVideo,
        "Premium_Sound": premiumSound,
        "Heads_Up_Display": headsUpDisplay,
        "Aux_Audio": auxAudio,
        "Bluetooth": bluetooth,
        "Climate_Control": climateControl,
        "Keyless_Entry": keylessEntry,
        "Keyless_Start": keylessStart,
        "Leather_Seats": leatherSeats,
        "Racing_Seats": racingSeats,
        "Cooled_Seats": cooledSeats,
        "Heated_Seats": heatedSeats,
        "Power_Seats": powerSeats,
        "Power_Locks": powerLocks,
        "Power_Mirrors": powerMirrors,
        "Power_Windows": powerWindows,
        "Memory_Seats": memorySeats,
        "View_Camera": viewCamera,
        "Blind_Spot_Indicator": blindSpotIndicator,
        "Anti_Lock": antiLock,
        "Adaptive_Cruise_Control": adaptiveCruiseControl,
        "Power_Steering": powerSteering,
        "Night_Vision": nightVision,
        "Lift_Kit": liftKit,
        "Park_Assist": parkAssist,
        "Adaptive_Suspension": adaptiveSuspension,
        "Height_Control": heightControl,
        "Navigation_System": navigationSystem,
        "Drives": drives,
        "Sunroof_Type": sunroofType,
        "N29_System": n29System,
        "Side_Steps": sideSteps,
        "Convertible": convertible,
        "Other_Features": otherFeatures,
        "Carbon_Fiber_Interior": carbonFiberInterior,
        "Line_Change_Assist": lineChangeAssist,
      };
}

class Steering {
  String brakePads;
  String brakeDiscsOrLining;
  String parkingBrakeOperations;
  String suspension;
  String shockAbsorberOperation;
  String steeringOperation;
  String steeringAlignment;
  String wheelAlignment;
  dynamic steeringComment;
  String rotorsAndDrums;
  String strutsAndShocks;

  Steering({
    this.brakePads,
    this.brakeDiscsOrLining,
    this.parkingBrakeOperations,
    this.suspension,
    this.shockAbsorberOperation,
    this.steeringOperation,
    this.steeringAlignment,
    this.wheelAlignment,
    this.steeringComment,
    this.rotorsAndDrums,
    this.strutsAndShocks,
  });

  factory Steering.fromJson(Map<String, dynamic> json) => Steering(
        brakePads: json["Brake_Pads"],
        brakeDiscsOrLining: json["Brake_Discs_Or_Lining"],
        parkingBrakeOperations: json["Parking_Brake_Operations"],
        suspension: json["Suspension"],
        shockAbsorberOperation: json["Shock_Absorber_Operation"],
        steeringOperation: json["Steering_Operation"],
        steeringAlignment: json["Steering_Alignment"],
        wheelAlignment: json["Wheel_Alignment"],
        steeringComment: json["Steering_Comment"],
        rotorsAndDrums: json["Rotors_and_Drums"],
        strutsAndShocks: json["Struts_and_Shocks"],
      );

  Map<String, dynamic> toJson() => {
        "Brake_Pads": brakePads,
        "Brake_Discs_Or_Lining": brakeDiscsOrLining,
        "Parking_Brake_Operations": parkingBrakeOperations,
        "Suspension": suspension,
        "Shock_Absorber_Operation": shockAbsorberOperation,
        "Steering_Operation": steeringOperation,
        "Steering_Alignment": steeringAlignment,
        "Wheel_Alignment": wheelAlignment,
        "Steering_Comment": steeringComment,
        "Rotors_and_Drums": rotorsAndDrums,
        "Struts_and_Shocks": strutsAndShocks,
      };
}

class Wheels {
  int frontRight;
  int rearRight;
  int frontLeft;
  int rearLeft;
  int spareTyre;
  String tyresComment;
  String rimType;
  String rimCondition;

  Wheels({
    this.frontRight,
    this.rearRight,
    this.frontLeft,
    this.rearLeft,
    this.spareTyre,
    this.tyresComment,
    this.rimType,
    this.rimCondition,
  });

  factory Wheels.fromJson(Map<String, dynamic> json) => Wheels(
        frontRight: json["FrontRight"],
        rearRight: json["RearRight"],
        frontLeft: json["FrontLeft"],
        rearLeft: json["RearLeft"],
        spareTyre: json["Spare_Tyre"],
        tyresComment: json["Tyres_Comment"],
        rimType: json["rim_type"],
        rimCondition: json["rim_condition"],
      );

  Map<String, dynamic> toJson() => {
        "FrontRight": frontRight,
        "RearRight": rearRight,
        "FrontLeft": frontLeft,
        "RearLeft": rearLeft,
        "Spare_Tyre": spareTyre,
        "Tyres_Comment": tyresComment,
        "rim_type": rimType,
        "rim_condition": rimCondition,
      };
}

class MyBid {
  int id;
  int carId;
  int userId;
  int auctionId;
  int bid;
  DateTime createdAt;

  MyBid({
    this.id,
    this.carId,
    this.userId,
    this.auctionId,
    this.bid,
    this.createdAt,
  });

  factory MyBid.fromJson(Map<String, dynamic> json) => MyBid(
        id: json["id"],
        carId: json["car_id"],
        userId: json["user_id"],
        auctionId: json["auction_id"],
        bid: json["bid"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "car_id": carId,
        "user_id": userId,
        "auction_id": auctionId,
        "bid": bid,
        "created_at": createdAt.toIso8601String(),
      };
}

class MyOffer {
  int id;
  int carId;
  int userId;
  int amount;
  DateTime createdAt;

  MyOffer({
    this.id,
    this.carId,
    this.userId,
    this.amount,
    this.createdAt,
  });

  factory MyOffer.fromJson(Map<String, dynamic> json) => MyOffer(
        id: json["id"],
        carId: json["car_id"],
        userId: json["user_id"],
        amount: json["amount"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "car_id": carId,
        "user_id": userId,
        "amount": amount,
        "created_at": createdAt.toIso8601String(),
      };
}
