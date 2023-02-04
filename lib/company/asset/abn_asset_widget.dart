// import 'dart:ffi';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../providers/firestore.dart';

class ABNAssetWidget extends ConsumerWidget {
  late String _linkedinData;
  final DocumentReference asset;

  ABNAssetWidget(this.asset);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
        title: Text('ABN'),
        subtitle: ref.watch(docSP(asset.path)).when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (assetDoc) => Text("${assetDoc.data()?['url'] ?? ''}")),
        isThreeLine: true,
      );
}
