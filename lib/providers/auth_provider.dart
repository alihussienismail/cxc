import 'dart:convert';
import 'dart:developer';

import 'package:carsxchange/constants/global.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pusher_client/pusher_client.dart';

import '../models/user_model.dart';

class Auth with ChangeNotifier {
  User _user;

  User get user => _user;

  Future<bool> register(String name, String email, String phone,
      String password, String passwordConfirmation) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$BASE_URL/api/v1/register'),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'phoneNumber': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  String _authToken;

  String get authToken => _authToken;

  bool _pushOnNewAuction = true;

  bool get pushOnNewAuction => _pushOnNewAuction;

  bool _pushIfWonAuction = true;

  bool get pushIfWonAuction => _pushIfWonAuction;

  Future<bool> login(String email, String password) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$BASE_URL/api/v1/login'),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }
      Map responseDecoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _authToken = responseDecoded["token_type"] +
            " " +
            responseDecoded["access_token"];
        _user = userFromJson(responseDecoded["user"]);

        try {
          PusherOptions options = PusherOptions(
            cluster: "eu",
            host: 'api.carsxchange.com',
            encrypted: true,
            auth: PusherAuth(
              'https://api.carsxchange.com/public/api/v1/pusher/auth-channel',
              headers: {
                'Authorization': 'Bearer $_authToken',
              },
            ),
          );

          pusher =
              PusherClient("9d45400630a8fa077501", options, autoConnect: true);
          await pusher.connect();
        } catch (e) {
          print("ERRORR: $e");
        }

        notifyListeners();
        await storage.write(key: "user", value: userToJson(_user));
        await storage.write(key: "authToken", value: _authToken);
        await storage.write(key: "notifyOnNewAuction", value: "true");
        await storage.write(key: "notifyIfWonAuction", value: "true");
        try {
          await OneSignal.shared.sendTags(
              {"notifyOnNewAuction": "true", "notifyIfWonAuction": "true"});
        } catch (e) {
          // onesignal error occurred
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  bool get isAuth => _authToken != null;

  Future<bool> tryAutoLogin() async {
    if (await storage.containsKey(key: 'user') &&
        await storage.containsKey(key: 'authToken')) {
      _user = userFromJson(jsonDecode(await storage.read(key: 'user')));
      _authToken = await storage.read(key: 'authToken');
      _pushIfWonAuction =
          await storage.read(key: 'notifyIfWonAuction') == "true";
      _pushOnNewAuction =
          await storage.read(key: 'notifyOnNewAuction') == "true";

      if (kDebugMode) {
        log("TOKEN IS: $_authToken");
      }

      try {
        PusherOptions options = PusherOptions(
          cluster: "eu",
          host: 'api.carsxchange.com',
          encrypted: true,
          auth: PusherAuth(
            'https://api.carsxchange.com/public/api/v1/pusher/auth-channel',
            headers: {
              'Authorization': 'Bearer $_authToken',
            },
          ),
        );

        pusher =
            PusherClient("9d45400630a8fa077501", options, autoConnect: true);
        await pusher.connect();
      } catch (e) {
        print("ERRORR: $e");
      }

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logOut() async {
    try {
      await storage.delete(key: 'user');
      await storage.delete(key: 'authToken');
      await OneSignal.shared
          .deleteTags(["notifyIfWonAuction", "notifyOnNewAuction"]);
      _authToken = null;
      _user = null;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$BASE_URL/api/v1/reset-password'),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: jsonEncode({'email': email}),
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$BASE_URL/api/v1/new-password'),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': _authToken
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPassword
        }),
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateNotificationSettings(
      {@required bool emailWinningAuction,
      @required bool emailNewAuction,
      @required bool notifyWinningAuction,
      @required bool notifyNewAuction}) async {
    try {
      http.Response response = await http.put(
        Uri.parse('$BASE_URL/api/v1/profile/notifications'),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': _authToken
        },
        body: jsonEncode({
          'notify_won_auction': emailWinningAuction,
          'notify_new_auction': emailNewAuction
        }),
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }

      if (response.statusCode == 200) {
        Map responseDecoded = jsonDecode(response.body);
        _user = userFromJson(responseDecoded["user"]);
        _pushIfWonAuction = notifyWinningAuction;
        _pushOnNewAuction = notifyNewAuction;
        await storage.write(
            key: "notifyOnNewAuction", value: "$notifyNewAuction");
        await storage.write(
            key: "notifyIfWonAuction", value: "$notifyWinningAuction");
        notifyListeners();
        await storage.write(key: "user", value: userToJson(_user));
        await OneSignal.shared.sendTags({
          "notifyOnNewAuction": "$notifyNewAuction",
          "notifyIfWonAuction": "$notifyWinningAuction"
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  Future<User> getUserInfo() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$BASE_URL/api/v1/profile'),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': _authToken
        },
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }
      Map responseDecoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _user = userFromJson(responseDecoded);
        notifyListeners();
        await storage.write(key: "user", value: userToJson(_user));
        return _user;
      } else {
        return _user;
      }
    } catch (e) {
      if (kDebugMode) {
        log("Error occurred fetching profile details: $e");
      }
      return null;
    }
  }

  Future<bool> updateUserInfo(
      {@required String name,
      @required String email,
      @required String phone,
      @required String company}) async {
    try {
      http.Response response = await http.put(
        Uri.parse('$BASE_URL/api/v1/profile'),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': _authToken
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'phoneNumber': phone,
          'company': company
        }),
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }
      Map responseDecoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _user = userFromJson(responseDecoded["user"]);
        notifyListeners();
        await storage.write(key: "user", value: userToJson(_user));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> requestAccountDeletion() async {
    try {
      http.Response response = await http.post(
        Uri.parse('$BASE_URL/api/v1/profile/deactivate'),
        headers: {'accept': 'application/json', 'authorization': _authToken},
      );
      if (kDebugMode) {
        log("DEBUG_MESSAGE: status code is:  ${response.statusCode}");
        log("DEBUG_MESSAGE: response is:  ${response.body}");
      }
      if (response.statusCode == 200) {
        await storage.delete(key: 'user');
        await storage.delete(key: 'authToken');
        await OneSignal.shared
            .deleteTags(["notifyIfWonAuction", "notifyOnNewAuction"]);
        _authToken = null;
        _user = null;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
