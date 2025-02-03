// ignore_for_file: unused_import

import 'package:flutter/material.dart';

var this_year = DateTime.now().year.toString();

class AppConfig {
  static String copyright_text =
      "@ EmeraldLightAuto " + this_year; //this shows in the splash screen
  static String app_name = "Emerald Light Auto"; //this shows in the splash screen
  static String purchase_code = "bkash";

  //Default language config
  static String default_language = "en";
  static String mobile_app_code = "en";
  static bool app_language_rtl = false;

  //configure this
  static const bool HTTPS = true;

  //configure this
  //static const DOMAIN_PATH = "emeraldlightauto.uk"; //localhost
  static const DOMAIN_PATH = "car.airsoftauctions.co.uk"; // directly inside the
  //static const DOMAIN_PATH = "auction.picklejargives.com";
  // public folder

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "${PROTOCOL}${DOMAIN_PATH}";
  static const String BASE_URL = "${RAW_BASE_URL}/${API_ENDPATH}";
}
