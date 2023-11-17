import 'dart:convert';

User userFromJson(Map jsonMap) => User.fromJson(jsonMap);

String userToJson(User data) => json.encode(data.toJson());

class User {
  int id;
  String name;
  String email;
  String status;
  String type;
  String phone;
  int isVerified;
  String company;
  int bidLimit;
  bool notifyNewAuction;
  bool notifyWonAuction;

  User({
    this.id,
    this.name,
    this.email,
    this.status,
    this.type,
    this.phone,
    this.isVerified,
    this.company,
    this.bidLimit,
    this.notifyNewAuction,
    this.notifyWonAuction,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        status: json["status"],
        type: json["type"],
        phone: json["phone"],
        isVerified: json["is_verified"],
        company: json["company"],
        bidLimit: json["bid_limit"],
        notifyNewAuction: json["notify_new_auction"],
        notifyWonAuction: json["notify_won_auction"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "status": status,
        "type": type,
        "phone": phone,
        "is_verified": isVerified,
        "company": company,
        "bid_limit": bidLimit,
        "notify_new_auction": notifyNewAuction,
        "notify_won_auction": notifyWonAuction,
      };
}
