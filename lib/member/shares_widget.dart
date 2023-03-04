import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

import '../common.dart';
import '../providers/firestore.dart';

class SharesWidget extends ConsumerWidget {
  final String companyId;
  SharesWidget(this.companyId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('company/$companyId/member/${CURRENT_USER.uid}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (memberDoc) => memberDoc.exists
              ? Column(
                  children: [
                    Text('shares history:'),
                    buildSharesLedger(memberDoc, ref)
                  ],
                )
              : Text('${memberDoc}'));

  Widget buildSharesLedger(
      DocumentSnapshot<Map<String, dynamic>> doc, WidgetRef ref) {
    return ref
        .watch(
            colSP('company/$companyId/member/${CURRENT_USER.uid}/shareLedger'))
        .when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (ledger) => ledger.docs.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: ledger.docs.length,
                    itemBuilder: (context, index) {
                      final doc = ledger.docs[index];
                      return ListTile(
                        title: Text(doc.data()['stake'].toString()),
                        subtitle:
                            Text(doc.data()['timestamp'].toDate().toString()),
                      );
                    })
                : Text('No shares ledger'));
  }
}
