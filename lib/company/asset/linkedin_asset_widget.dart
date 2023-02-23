// import 'dart:ffi';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../providers/firestore.dart';

class LinkedInAssetWidget extends ConsumerWidget {
  late String _linkedinData;
  final DocumentReference asset;
  final String entityId;

  static const AssetType _type = AssetType.LinkedIn;

  LinkedInAssetWidget(this.asset, this.entityId);

  Future<String> _getLinkedinData(String id) async {
    final keyDoc = await FirebaseFirestore.instance.doc('api/rapidApi').get();
    final response = await http.post(
        Uri.parse(
            'https://linkedin-company-data.p.rapidapi.com/linkedInCompanyDataJson'),
        headers: {
          'content-type': 'application/json',
          'X-RapidAPI-Key': keyDoc.get('key'),
          'X-RapidAPI-Host': 'linkedin-company-data.p.rapidapi.com'
        },
        body: json.encode({
          "liUrls": [getAssetUrl(AssetType.LinkedIn, id)]
        }));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      await asset.update({
        "followers": (body['Results'][0]['FollowerCount'] ??
            'Could not find follower count')
      });
      await FirebaseFirestore.instance
          .doc("company/${entityId}")
          .update({'logo': (body['Results'][0]['Logo'])});
      print(response.body);
      return _linkedinData = response.body;
    } else {
      throw Exception("No data found");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP(asset.path)).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (assetDoc) => Card(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                            '${AssetType.LinkedIn.name} - ${data(assetDoc, 'id')}'),
                        subtitle:
                            Text("followers: ${data(assetDoc, 'followers')}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () =>
                              _getLinkedinData(data(assetDoc, 'id')),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 15),
                        child: ActionChip(
                          avatar: const Icon(
                            Icons.open_in_new_rounded,
                            color: Colors.black26,
                            size: 18,
                          ),
                          label: Text(
                              "${getAssetUrl(_type, data(assetDoc, 'id'))}"),
                          onPressed: () => openAssestWebpage(
                              _type, data(assetDoc, 'id'), context),
                        ),
                      ),
                    ]),
              ));
}
