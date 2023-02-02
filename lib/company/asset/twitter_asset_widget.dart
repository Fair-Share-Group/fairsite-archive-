import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/common.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TwitterAssetWidget extends ConsumerWidget {
  final DocumentReference asset;

  TwitterAssetWidget(this.asset);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(docSP(asset.path)).when(
    loading: () => Container(), 
    error: (e, s) => ErrorWidget(e), 
    data: (assetDoc) => ListTile(
      title: Text('Twitter - ${assetDoc.data()?["url"]}'),
      subtitle: Text(''),
      isThreeLine: true,
      trailing: IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          //API Call...
        },
      ),
      onTap: () => openUrl(assetDoc.data()?["url"], context)
      ), 
    );
}
