import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

const DATE_FORMAT = 'yyyy-MM-dd';
final CURRENT_USER = FirebaseAuth.instance.currentUser!;
final DB = FirebaseFirestore.instance;
final AUTH = FirebaseAuth.instance;

List<Jiffy> generateWeeks(Jiffy start, Jiffy end) {
  List<Jiffy> list = [];
  Jiffy current = start;
  for (var i = 0; i < 1000; i++) {
    if (current.isAfter(end)) {
      break;
    }
    list.add(current);
    current = Jiffy(Jiffy(current).add(days: 8)).startOf(Units.WEEK);
  }
  return list;
}

List<Jiffy> generateMonths(Jiffy start, Jiffy end) {
  List<Jiffy> list = [];
  Jiffy current = Jiffy(start).startOf(Units.MONTH);
  for (var i = 0; i < 1000; i++) {
    if (current.isAfter(end)) {
      break;
    }
    list.add(current);
    current = Jiffy(current).add(days: 32).startOf(Units.MONTH);
  }
  return list;
}

List<Jiffy> generateDays(Jiffy start, Jiffy end) {
  List<Jiffy> list = [];
  Jiffy current = start;
  for (var i = 0; i < 1000; i++) {
    if (current.isAfter(end)) {
      break;
    }
    list.add(current);
    current = Jiffy(current).add(days: 1).startOf(Units.DAY);
  }
  return list;
}

openUrl(String url, BuildContext context) async {
  url = url.trim();
  if (url.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("No url found for this asset")));
    return;
  }

  // for launchUrl to work properly, urls need to start with http:// or https://
  // otherwise it will be treated as a relative link 
  if (!url.startsWith(RegExp(r"https?://"))) {
    url = "https://$url";
  }
  if (!await launchUrl(Uri.parse(url))) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Could not open $url")));
  }
}

openAssetWebpage(AssetType assetType, String id, BuildContext context) async {
  id = id.trim();
  if (id.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("No id found for this asset")));
    return;
  }

  var url = getAssetUrl(assetType, id);
  

  if (!await launchUrl(Uri.parse(url))) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Could not open $url")));
  }
}

// Get full form correct url 
String getAssetUrl(AssetType assetType, String id) {
switch (assetType) {
    case AssetType.LinkedIn:
      return "https://www.linkedin.com/company/$id/";
    case AssetType.Twitter:
      return "https://twitter.com/$id/";
    case AssetType.Facebook:
      return "https://www.facebook.com/$id/";
    case AssetType.ABN:
      return "https://abr.business.gov.au/ABN/View?abn=$id/";
    case AssetType.Website:
      return id;
  }
}

// Get url used for displaying
String getAssetDisplayUrl(AssetType assetType, String id) {
  switch (assetType) {
    case AssetType.LinkedIn:
      return "linkedin.com/company/$id/";
    case AssetType.Twitter:
      return "twitter.com/$id/";
    case AssetType.Facebook:
      return "facebook.com/$id/";
    case AssetType.ABN:
      return "abr.business.gov.au/ABN/View?abn=$id/";
    case AssetType.Website:
      return id;
  }
}

dynamic data(DocumentSnapshot<Map<String, dynamic>> doc, String field) {
  return doc.data()?[field] ?? "field \"$field\" was not used when creating this asset";
}


enum AssetType {
  LinkedIn,
  Facebook, 
  Twitter, 
  ABN,
  Website
}

const WIDE_SCREEN_WIDTH = 600;

