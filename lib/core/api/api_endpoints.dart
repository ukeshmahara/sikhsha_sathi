import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = true;
  static const String compIpAddress = '192.168.18.10';
  static const int apiPort = 8089;

  static String get baseUrl {
    if (isPhysicalDevice) {
      return 'http://$compIpAddress:$apiPort/api/v1';
    }

    if (kIsWeb) {
      return 'http://localhost:$apiPort/api/v1';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:$apiPort/api/v1';
    } else if (Platform.isIOS) {
      return 'http://localhost:$apiPort/api/v1';
    } else {
      return 'http://localhost:$apiPort/api/v1';
    }
  }

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String whoami = '/auth/whoami';
  static const String forgotPassword = '/auth/forgot-password';
  static const String profile = '/auth/profile';
  static const String profilePicture = '/auth/update';

  // School endpoints
  static const String schools = '/schools';
  static const String schoolCategoryCounts = '/schools/category-counts';

  // Favourite endpoints
  static const String favourites = '/favorites';

  // Notification endpoints
  static const String notifications = '/notifications';
}