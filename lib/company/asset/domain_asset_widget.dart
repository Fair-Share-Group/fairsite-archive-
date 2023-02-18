import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/common.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomainAssetWidget extends ConsumerWidget {
  final DocumentReference asset;
  static const AssetType _type = AssetType.Domain;

  DomainAssetWidget(this.asset);

 @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(docSP(asset.path)).when(
    loading: () => Container(), 
    error: (e, s) => ErrorWidget(e), 
    data: (assetDoc) => Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
      title: Text(_type.name),
      subtitle: Text(data(assetDoc, 'id')),
      trailing: IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          //API Call...
        },
      ),
      ),
      Padding(padding: const EdgeInsets.only(left: 15, bottom: 15), child: ActionChip(
            avatar: const Icon(Icons.open_in_new_rounded, color: Colors.black26, size: 18,),
            label: Text("${getAssetUrl(_type, data(assetDoc, 'id'))}"),
            onPressed: () => openAssestWebpage(_type, data(assetDoc, 'id'), context),
            ),
      ),
      ]),
    ) 
    );
}
