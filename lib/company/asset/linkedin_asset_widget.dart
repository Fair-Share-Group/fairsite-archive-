// import 'dart:ffi';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../providers/firestore.dart';

import 'package:flutter_svg/flutter_svg.dart';


class LinkedInAssetWidget extends ConsumerWidget {
  late String _linkedinData;
  final DocumentReference asset;

  static const AssetType _type = AssetType.LinkedIn;


  LinkedInAssetWidget(this.asset);

  Future<String> _getLinkedinData(String id) async {
    final keyDoc = await DB.doc('api/rapidApi').get();
    final response = await http.post(
        Uri.parse(
            'https://linkedin-company-data.p.rapidapi.com/linkedInCompanyDataJsonV3Beta?liUrl=${getAssetUrl(AssetType.LinkedIn, id)}'),
        headers: {
          'content-type': 'application/json',
          'X-RapidAPI-Key': keyDoc.get('key'),
          'X-RapidAPI-Host': 'linkedin-company-data.p.rapidapi.com'
        }); //Example data (should use the company linkedin url in the uri.parse and the correct API key)
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      await asset.update({"followers": (body['results']['followerCount'] ?? 'Could not find follower count')});
      return _linkedinData = response.body;
    } else {
      throw Exception("No data found");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(docSP(asset.path)).when(
    loading: () => Container(), 
    error: (e, s) => ErrorWidget(e), 
    data: (assetDoc) => Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Padding(padding: const EdgeInsets.only(left: 15), child: 
            SvgPicture.asset('assets/svg/linkedin.svg', width: 36, height: 36,),
          ),
          Expanded(child: ListTile(
          title: Text('${AssetType.LinkedIn.name} - ${data(assetDoc, 'id')}'),
          subtitle: Text("followers: ${data(assetDoc, 'followers')}"),
          trailing: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _getLinkedinData(data(assetDoc, 'id')),
          ),)
          )
      ])
        ,
      Padding(padding: const EdgeInsets.only(left: 15, bottom: 15), child: ActionChip(
            avatar: const Icon(Icons.open_in_new_rounded, color: Colors.black26, size: 18,),
            label: Text("${getAssetDisplayUrl(_type, data(assetDoc, 'id'))}"),
            onPressed: () => openAssetWebpage(_type, data(assetDoc, 'id'), context),
            ),
      ),
      ]),
    ) 
    );
}