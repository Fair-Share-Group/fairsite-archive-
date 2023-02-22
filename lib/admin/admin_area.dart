import 'dart:math';

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
          const Text('Admin Area'),
          buildMembers(ref),
        ],
      );

  Widget buildMembers(WidgetRef ref) {
    final tec = TextEditingController();
    return Column(children: [
      const Text('members:'),
      Column(
          children: ref.watch(colSP('company/${companyId}/member')).when(
              loading: () => [],
              error: (e, s) => [],
              data: (members) {
                var ls = members.docs.map((e) => Text(e.id)).toList();
                var memberListRemove = List.generate(
                    ls.length,
                    (index) => (Padding(
                        padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ls[index],
                              TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('company/${companyId}/member')
                                      .doc(ls[index].data)
                                      .delete()
                                      .then((value) {
                                    print("Deleted " + ls[index].data!);
                                  }).catchError((err) => print(err));
                                },
                                child: const Text("Remove "),
                              )
                            ]))));
                return memberListRemove;
              })),
      TextField(
        controller: tec,
      ),
      TextButton(
          onPressed: () => FirebaseFirestore.instance
              .collection('company/${companyId}/member')
              .doc(tec.text)
              .set({'timeJoined': FieldValue.serverTimestamp()}),
          child: const Text('Add')),
    ]);
  }
}
