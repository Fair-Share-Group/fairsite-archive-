// import 'dart:ffi';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../providers/firestore.dart';

class ABNAssetWidget extends ConsumerWidget {
  late String _linkedinData;
  final DocumentReference asset;

  static const AssetType _type = AssetType.ABN;

  ABNAssetWidget(this.asset); 

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(docSP(asset.path)).when(
    loading: () => Container(), 
    error: (e, s) => ErrorWidget(e), 
    data: (assetDoc) => Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Padding(padding: const EdgeInsets.only(left: 15), child: 
            Icon(Icons.numbers_rounded, size: 36,),
          ),
          Expanded(child: ListTile(
            title: Text(_type.name),
            subtitle: Text(data(assetDoc, 'id')),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {},
              ),)
          )
      ]),
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