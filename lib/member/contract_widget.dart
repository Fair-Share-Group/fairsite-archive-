import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

import '../common.dart';
import '../providers/firestore.dart';

class ContractWidget extends ConsumerWidget {
  final String companyId;
  ContractWidget(this.companyId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('company/$companyId/member/${CURRENT_USER.uid}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (memberDoc) => memberDoc.exists
              ? Column(
                  children: [
                    Text('contract area'),
                    Text(getContractFromDoc(memberDoc)),
                    buildContractSignedLabel(memberDoc),
                    buildSignContractButton(memberDoc)
                  ],
                )
              : Text('${memberDoc}'));

  String getContractFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return doc.data()!['contract'];
  }

  Widget buildSignContractButton(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.data()!['status'] == 'signed') return Container();

    return ElevatedButton(
        child: Text('Sign contract'),
        onPressed: () {
          doc.reference
              .update({'status': 'signed', 'signedDate': DateTime.now()});
        });
  }

  Widget buildContractSignedLabel(DocumentSnapshot<Map<String, dynamic>> doc) {
    return doc.data()!['status'] == 'signed'
        ? Text(
            'Contract signed on ${Jiffy(doc.data()!['signedDate'].toDate()).format(DATE_FORMAT)}')
        : Text('Contract not signed');
  }
}
