import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/firestore.dart';
import 'package:fairsite/common.dart';

class AdminArea extends ConsumerWidget {
  final String companyId;
  AdminArea(this.companyId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('company/$companyId/admin/${CURRENT_USER.uid}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (adminDoc) => adminDoc.exists
              ? buildAdminTools(ref)
              : Text(
                  'uid ${CURRENT_USER.uid} is not an admin of ${companyId}'));

  Widget buildAdminTools(WidgetRef ref) => Column(
        children: [
          Text('Admin Area'),
          buildMembers(ref),
        ],
      );

  Widget buildMembers(WidgetRef ref) {
    final tec = TextEditingController();
    return Column(children: [
      Text('members:'),
      Column(
          children: ref.watch(colSP('company/${companyId}/member')).when(
              loading: () => [],
              error: (e, s) => [],
              data: (members) => members.docs.map((e) => Text(e.id)).toList())),
      TextField(
        controller: tec,
      ),
      TextButton(
          onPressed: () => FirebaseFirestore.instance
              .collection('company/${companyId}/member')
              .doc(tec.text)
              .set({'timeJoined': FieldValue.serverTimestamp()}),
          child: Text('Add'))
    ]);
  }
}
