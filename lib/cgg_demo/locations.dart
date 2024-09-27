import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'locations.g.dart';

@JsonSerializable()
class LatLng {
  LatLng({
    required this.lat,
    required this.lng,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double lat;
  final double lng;
}

@JsonSerializable()
class Region {
  Region({
    required this.coords,
    required this.id,
    required this.name,
    required this.zoom,
  });

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  Map<String, dynamic> toJson() => _$RegionToJson(this);

  final LatLng coords;
  final String id;
  final String name;
  final double zoom;
}

@JsonSerializable()
class Office {
  Office({
    required this.address,
    required this.id,
    required this.image,
    required this.lat,
    required this.lng,
    required this.name,
    required this.phone,
    required this.region,
  });

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeToJson(this);

  final String address;
  final String id;
  final String image;
  final double lat;
  final double lng;
  final String name;
  final String phone;
  final String region;
}

@JsonSerializable()
class Locations {
  Locations({
    required this.offices,
    required this.regions,
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<Office> offices;
  final List<Region> regions;
}

Future<Locations> getGoogleOffices() async {
  const googleLocationsURL = 'https://about.google/static/data/locations.json';

  // Retrieve the locations of Google offices
  try {
    final response = await http.get(Uri.parse(googleLocationsURL));
    if (response.statusCode == 200) {
      return Locations.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  // Fallback for when the above HTTP request fails.
  return Locations.fromJson(
    json.decode(
      await rootBundle.loadString('assets/assets/cgg_demo_assets/locations.json'),
    ) as Map<String, dynamic>,
  );
}

// -------------------------------- CGG STUFF -------------------------------------------

@JsonSerializable()
class CGGShopProfile {
  CGGShopProfile({
    required this.shop_id,
    required this.shop_name,
    required this.image_l,
    required this.address,
    required this.business_hours,
    required this.open_all_day,
    required this.close_all_day,
    required this.lat,
    required this.lng,
    required this.currency,
    required this.deposit,
    required this.shop_tel,
    required this.country_code,
  });

  factory CGGShopProfile.fromJson(Map<String, dynamic> json) => _$CGGShopProfileFromJson(json);
  Map<String, dynamic> toJson() => _$CGGShopProfileToJson(this);

  final String shop_id;
  final String shop_name;
  final String image_l;
  final String address;
  final String business_hours;
  final bool open_all_day;
  final bool close_all_day;
  final double lat;
  final double lng;
  final String currency;
  final int deposit;
  final String shop_tel;
  final String country_code;
}


@JsonSerializable()
class CGGShopProfileResponse {
  CGGShopProfileResponse({
    required this.ec,
    required this.em,
    required this.timestamp,
    required this.data,
    required this.msg,
  });

  factory CGGShopProfileResponse.fromJson(Map<String, dynamic> json) => _$CGGShopProfileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CGGShopProfileResponseToJson(this);

  final int ec;
  final String em;
  final int timestamp;
  final CggShopData data;
  final String msg;
}

@JsonSerializable()
class CGGShopProfileResponseNoTimestamp {
  CGGShopProfileResponseNoTimestamp({
    required this.ec,
    required this.em,
    required this.data,
    required this.msg,
  });

  factory CGGShopProfileResponseNoTimestamp.fromJson(Map<String, dynamic> json) => _$CGGShopProfileResponseNoTimestampFromJson(json);
  Map<String, dynamic> toJson() => _$CGGShopProfileResponseNoTimestampToJson(this);

  final int ec;
  final String em;
  final CggShopDataStringMode data;
  final String msg;
}

CGGShopProfileResponse convertProfileResponseNoTimeStamp(CGGShopProfileResponseNoTimestamp response) {
  var returnData = convertCggShopDataStringModeToCggShopData(response.data);
  return CGGShopProfileResponse(
    ec: response.ec,
    em: response.em,
    timestamp: 0,
    data: returnData,
    msg: response.msg,
  );
}


@JsonSerializable()
class CGGShopProfileStringMode {
  CGGShopProfileStringMode({
    required this.shop_id,
    required this.shop_name,
    required this.image_l,
    required this.address,
    required this.business_hours,
    required this.open_all_day,
    required this.close_all_day,
    required this.lat,
    required this.lng,
    required this.currency,
    required this.deposit,
    required this.shop_tel,
    required this.country_code,
  });

  factory CGGShopProfileStringMode.fromJson(Map<String, dynamic> json) => _$CGGShopProfileStringModeFromJson(json);
  Map<String, dynamic> toJson() => _$CGGShopProfileStringModeToJson(this);

  final String shop_id;
  final String shop_name;
  final String image_l;
  final String address;
  final String business_hours;
  final bool open_all_day;
  final bool close_all_day;
  final String lat;
  final String lng;
  final String currency;
  final String deposit;
  final String shop_tel;
  final String country_code;
}

CGGShopProfile convertCGGShopProfileStringModeToCGGShopProfile(CGGShopProfileStringMode shopProfile) {
  return CGGShopProfile(
    shop_id: shopProfile.shop_id,
    shop_name: shopProfile.shop_name,
    image_l: shopProfile.image_l,
    address: shopProfile.address,
    business_hours: shopProfile.business_hours,
    open_all_day: shopProfile.open_all_day,
    close_all_day: shopProfile.close_all_day,
    lat: double.parse(shopProfile.lat),
    lng: double.parse(shopProfile.lng),
    currency: shopProfile.currency,
    deposit: int.parse(shopProfile.deposit),
    shop_tel: shopProfile.shop_tel,
    country_code: shopProfile.country_code,
  );
}

@JsonSerializable()
  class CGGShopSlots {
    CGGShopSlots({
      required this.on,
      required this.off
    });

    factory CGGShopSlots.fromJson(Map<String, dynamic> json) => _$CGGShopSlotsFromJson(json);
    Map<String, dynamic> toJson() => _$CGGShopSlotsToJson(this);

    final int on;
    final int off;
  }

@JsonSerializable()
class CggShopData {
  CggShopData({
    required this.profile,
    required this.pricing_str,
    required this.display_type,
    required this.slots,
    required this.available,
  });

  factory CggShopData.fromJson(Map<String, dynamic> json) => _$CggShopDataFromJson(json);
  Map<String, dynamic> toJson() => _$CggShopDataToJson(this);

  final CGGShopProfile profile;
  final List<String> pricing_str;
  final String display_type;
  final CGGShopSlots slots;
  final bool available;
}

@JsonSerializable()
class CggShopDataStringMode {
  CggShopDataStringMode({
    required this.profile,
    required this.pricing_str,
    required this.display_type,
    required this.slots,
    required this.available,
  });

  factory CggShopDataStringMode.fromJson(Map<String, dynamic> json) => _$CggShopDataStringModeFromJson(json);
  Map<String, dynamic> toJson() => _$CggShopDataStringModeToJson(this);

  final CGGShopProfileStringMode profile;
  final List<String> pricing_str;
  final String display_type;
  final CGGShopSlots slots;
  final bool available;
}

CggShopData convertCggShopDataStringModeToCggShopData(CggShopDataStringMode shopData) {
  return CggShopData(
    profile: convertCGGShopProfileStringModeToCGGShopProfile(shopData.profile),
    pricing_str: shopData.pricing_str,
    display_type: shopData.display_type,
    slots: shopData.slots,
    available: shopData.available,
  );
}

@JsonSerializable()
class CGGShop {
  CGGShop({
    required this.id,
    required this.lat,
    required this.lng,
    required this.business_hours
  });

  factory CGGShop.fromJson(Map<String, dynamic> json) => _$CGGShopFromJson(json);
  Map<String, dynamic> toJson() => _$CGGShopToJson(this);

  final String id;
  final double lat;
  final double lng;
  final String business_hours;
}

@JsonSerializable()
class CGGShopStringMode {
  CGGShopStringMode({
    required this.id,
    required this.lat,
    required this.lng,
    required this.business_hours
  });

  factory CGGShopStringMode.fromJson(Map<String, dynamic> json) => _$CGGShopStringModeFromJson(json);
  Map<String, dynamic> toJson() => _$CGGShopStringModeToJson(this);

  final String id;
  final String lat;
  final String lng;
  final String business_hours;
}

@JsonSerializable()
class CGGShops {
  CGGShops({
    this.shops = const <CGGShop>[],
  });
 
  factory CGGShops.fromJson(Map<String, dynamic> json) => 
      _$CGGShopsFromJson(json);
  Map<String, dynamic> toJson() => _$CGGShopsToJson(this);

  final List<CGGShop> shops;
}

@JsonSerializable()
class CGGShopsStringMode {
  CGGShopsStringMode({
    this.shops = const<CGGShopStringMode>[],
  });

  factory CGGShopsStringMode.fromJson(Map<String, dynamic> json) =>
      _$CGGShopsStringModeFromJson(json);

  Map<String, dynamic> toJson() => _$CGGShopsStringModeToJson(this);

  final List<CGGShopStringMode> shops;
}

@JsonSerializable()
class GetShopListApiResponseNoTimestamp {
  GetShopListApiResponseNoTimestamp({
    required this.ec,
    required this.em,
    required this.msg,
    required this.data,
  });

  factory GetShopListApiResponseNoTimestamp.fromJson(Map<String, dynamic> json) =>
      _$GetShopListApiResponseNoTimestampFromJson(json);
  Map<String, dynamic> toJson() => _$GetShopListApiResponseNoTimestampToJson(this);

  final int ec;
  final String em;
  final String msg;
  final CGGShopsStringMode data;
}

@JsonSerializable()
class GetShoplistAPIResponse {
  GetShoplistAPIResponse({
    required this.ec,
    required this.em,
    required this.timestamp,
    required this.data,
  });

  factory GetShoplistAPIResponse.fromJson(Map<String, dynamic> json) =>
      _$GetShoplistAPIResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetShoplistAPIResponseToJson(this);

  final int ec;
  final String em;
  final int timestamp;
  final CGGShops data;
}

Future<CggShopData?> getCGGShopProfileAPIResponse(String id) async {
  String cggShopProfileURL = 'https://api.chargergogo.com/api/v2/shops/$id';
  try {
    final response = await http.get(Uri.parse(cggShopProfileURL));
    print(response.body);
    if (response.statusCode == 200) {
      try {
        var apiResponse = CGGShopProfileResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
        return apiResponse.data;
      } catch (e) {
        print("Failed to decode response body: $e, response: ${response.body}");
      }

      try {
        CGGShopProfileResponse convertedResponse = convertProfileResponseNoTimeStamp(
          CGGShopProfileResponseNoTimestamp.fromJson(
            json.decode(response.body) as Map<String, dynamic>
          )
        );
        return convertedResponse.data;
      } catch (e) {
        print("Failed to decode response body: $e, response: ${response.body}");
      }

    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return null;
}

Future<CggShopData?> getCGGShopData(String id) async {
  var cggShopProfileResponse = await getCGGShopProfileAPIResponse(id);
  if (cggShopProfileResponse != null) {
    return cggShopProfileResponse;
  }
  return null;
}

Future<CGGShopProfile?> getCGGShopProfile(String id) async {
  var cggShopProfileResponse = await getCGGShopProfileAPIResponse(id);
  if (cggShopProfileResponse != null) {
    print(cggShopProfileResponse.profile.shop_name);
    return cggShopProfileResponse.profile;
  }
  return null;
}

CGGShop convertCGGShopStringModeToCGGShop(CGGShopStringMode shop) {
  return CGGShop(
    id: shop.id,
    lat: double.parse(shop.lat),
    lng: double.parse(shop.lng),
    business_hours: shop.business_hours,
  );
}

CGGShops convertCGGShopsStringModeToCGGShops(CGGShopsStringMode shops) {
  return CGGShops(
    shops: shops.shops.map((shop) => convertCGGShopStringModeToCGGShop(shop)).toList(),
  );
}

GetShoplistAPIResponse getShopListApiResponseFromNoTimestamp(GetShopListApiResponseNoTimestamp response) {
  return GetShoplistAPIResponse(
    ec: response.ec,
    em: response.em,
    timestamp: 0,
    data: convertCGGShopsStringModeToCGGShops(response.data),
  );
}

Future<CGGShops> getCGGShops() async {
  const cggShopsURL = 'https://api.chargergogo.com/api/v2/nearby/shoplist';
  try {
    final response = await http.post(Uri.parse(cggShopsURL),
    body: {
      'lat': '36.096',
      'lng': '-155.218',
      'is_usa': '1',
    }
    );
    // String response = '{"ec":200,"em":"ok","timestamp": 1724815918,"data":{"shops":[{"id":"13113","lat":-8.1191131,"lng":-34.8953107,"business_hours":"0:00-24:00"}]}}';
    // return GetShopAPIResponse.fromJson(json.decode(response) as Map<String, dynamic>).data;
    // print(response.body);
    if (response.statusCode == 200) {
      try {
        // check if response.body contains timestamp
        var apiResponse = GetShoplistAPIResponse.fromJson(
            json.decode(response.body) as Map<String, dynamic>);
        print("Timestamp!");
        return apiResponse.data;
      } catch (e) {
        print("Failed to decode response body for timestamped response: $e, response: ${response.body}");
      }

      try {
        // check if response.body does not contain timestamp
        var apiResponse = GetShopListApiResponseNoTimestamp.fromJson(
            json.decode(response.body) as Map<String, dynamic>);

        print("No timestamp!");
        GetShoplistAPIResponse convertedResponse = getShopListApiResponseFromNoTimestamp(apiResponse);
        return CGGShops(shops: convertedResponse.data.shops);
      } catch (e) {
        print("Failed to decode response body for non-timestamped: $e, response: ${response.body}");
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  // Fallback for when the above HTTP request fails.
  return CGGShops.fromJson(
    json.decode(
      await rootBundle.loadString('assets/assets/cgg_demo_assets/shops.json'),
    ) as Map<String, dynamic>,
  );
}
