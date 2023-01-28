// import 'dart:ffi';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class LinkedInAssetWidget extends ConsumerWidget {
  late String _linkedinData;
  final DocumentReference asset;
  LinkedInAssetWidget(this.asset);
  Future<String> _getLinkedinData() async {
    final keyDoc = await FirebaseFirestore.instance.doc('api/rapidApi').get();
    final response = await http.post(
        Uri.parse(
            'https://linkedin-company-data.p.rapidapi.com/linkedInCompanyDataJsonV3Beta?liUrl=https://www.linkedin.com/company/swapu/'),
        headers: {
          'content-type': 'application/json',
          'X-RapidAPI-Key': keyDoc.get('key'),
          'X-RapidAPI-Host': 'linkedin-company-data.p.rapidapi.com'
        }); //Example data (should use the company linkedin url in the uri.parse and the correct API key)
    if (response.statusCode == 200) {
      //print(response.body['results']); // to see what the api returns
      var body = jsonDecode(response.body);
      print(body);
      print(body['results']['followerCount']);
      await asset.update({"followers": body['results']['followerCount']});
      return _linkedinData = response.body;
    } else {
      throw Exception("No data found");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
        title: Text('LinkedIn'),
        subtitle: Text('s'),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            _getLinkedinData();
          },
        ),
      );
}
