import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pusher_client/pusher_client.dart';

const String BASE_URL = 'https://api.carsxchange.com';
// const String BASE_URL = 'http://10.0.0.16/cxc/public';

FlutterSecureStorage storage;

String isSeenOnBoarding = 'false';
PusherClient pusher;
AudioPlayer newBidAudioPlayer = AudioPlayer();

int selectedNavigationIndex = 1;
bool isEnglish = false;
