import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:fairsite/controls/doc_field_text_edit.dart';
import 'package:fairsite/lists/lists_page.dart';
import 'package:fairsite/providers/firestore.dart';

import 'asset_list.dart';

class ListInfo extends ConsumerWidget {
  final String entityId;
  const ListInfo(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('company/${entityId}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (entityDoc) => Column(children: [
                Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                          child: Text(
                        (entityDoc.data()!['name'] != null)
                            ? entityDoc.data()!['name']
                            : 'no name',
                      )),
                      // Flexible(
                      //     child: Text('Last updated: ' +
                      //         Jiffy(entityDoc.data()!['lastUpdateTime'] == null
                      //                 ? DateTime(0001, 1, 1, 00, 00)
                      //                 : entityDoc
                      //                     .data()!['lastUpdateTime']
                      //                     .toDate())
                      //             .format())),
                      // Flexible(
                      //     child: Text('Last changed: ' +
                      //         Jiffy(entityDoc.data()!['lastUpdateTime'] == null
                      //                 ? DateTime(0001, 1, 1, 00, 00)
                      //                 : entityDoc
                      //                     .data()!['lastUpdateTime']
                      //                     .toDate())
                      //             .format())),
                    ]),
                AssetListView(entityId),
              ]));
}
