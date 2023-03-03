import 'dart:io';

class Environment {
  static String apiUrl =
      Platform.isAndroid ? '192.168.0.109:3000' : 'localhost:3000';
  static String socketUrl =
      Platform.isAndroid ? '192.168.0.109:3000' : 'localhost:3000';
}
