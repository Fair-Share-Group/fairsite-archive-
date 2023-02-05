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

  ABNAssetWidget(this.asset);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(docSP(asset.path)).when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (assetDoc) => ListTile(
              title: Text(AssetType.ABN.name),
              subtitle: Text(data(assetDoc, 'id')),
              onTap: () => openAssestWebpage(AssetType.ABN, data(assetDoc, 'id'), context),
              isThreeLine: true,
              )
            );
}
