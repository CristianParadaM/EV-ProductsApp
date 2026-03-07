import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {

  Environments._();

  static String get firebaseClientId => dotenv.env['serverClientId'] ?? '';
  static String get apiBaseUrl => dotenv.env['apiBaseUrl'] ?? '';
  
  static String get versionApp => '1.0.0';
}

class ImagePaths {
  ImagePaths._();

  static  String get startImage => 'assets/images/start_img.png';
  static  String get loginGif => 'assets/images/192432399e346adfe113b36a81f22643.gif';
  static  String get registerGif => 'assets/images/original-6fa9aa5f9425ef0ca93899fd3c428f87.gif';
  
  static  String get splashAnimation => 'assets/animations/Paperplane.json';
}
