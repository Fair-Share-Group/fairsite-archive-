import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/common.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

Future<dynamic> _getTwitterData(String username) async {
  String apiUrl =
      "https://twitter154.p.rapidapi.com/user/details?username=${username.toLowerCase()}";

  final http.Response res = await http.get(
    Uri.parse("$apiUrl"),
    headers: {
      'X-RapidAPI-Key': 'e082e1c185mshc384dc4309007bcp1f62e0jsnf396270175ec',
      'X-RapidAPI-Host': 'twitter154.p.rapidapi.com'
    },
  );

  if (res.statusCode == 404) {
    return "User could not be found";
  }

  if (res.statusCode == 401 || res.statusCode == 403) {
    return "Application is not authenticated";
  }

  var body = jsonDecode(res.body);

  return body;
}

class TwitterAssetWidget extends ConsumerWidget {
  final DocumentReference asset;

  TwitterAssetWidget(this.asset);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(docSP(asset.path)).when(
    loading: () => Container(), 
    error: (e, s) => ErrorWidget(e), 
    data: (assetDoc) => ListTile(
      title: Text(AssetType.Twitter.name),
      subtitle: Text(data(assetDoc, 'id')),
      isThreeLine: true,
      trailing: IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          _getTwitterData("google").then((value) => print(value));
        },
      ),
      onTap: () => openAssestWebpage(AssetType.Twitter, data(assetDoc, 'id'), context),
      ), 
    );
}
