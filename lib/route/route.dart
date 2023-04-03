import 'package:flutter/material.dart';

// Define Routes
import 'package:named_route/views/auction.dart';
import 'package:named_route/views/featured.dart';
//import 'package:named_route/views/settings.dart';

// Route Names
const String auctionPage    = 'auction';
const String featuredPage     = 'featured';
//const String settingsPage = 'settings';

// Control our page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case auctionPage:
      return MaterialPageRoute(builder: (context) => AuctionPage());
    case featuredPage:
      return MaterialPageRoute(builder: (context) => FeaturedPage());
//     case settingsPage:
//       return MaterialPageRoute(builder: (context) => SettingsPage());
    default:
      throw('This route name does not exit');
  }
}
