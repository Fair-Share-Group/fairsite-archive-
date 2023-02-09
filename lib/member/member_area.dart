import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login/login.dart';

import '../providers/firestore.dart';
import 'package:fairsite/common.dart';

class MemberArea extends ConsumerWidget {
  final String companyId;
  MemberArea(this.companyId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('company/$companyId/member/${CURRENT_USER.uid}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (memberDoc) => memberDoc.exists
              ? buildMemberPanel(ref)
              : Text(
                  'uid ${CURRENT_USER.uid} is not a member of ${companyId}'));

  Widget buildMemberPanel(WidgetRef ref) {
    return Container(
        width: 700,
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black)),
        child: ListView(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text("MEMBER AREA FOR USER ${CURRENT_USER.displayName}",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ]),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("company/$companyId/member")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text("No members found");
                return Column(children: getMembers(snapshot));
              })
        ]));
  }

  getMembers(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map((doc) => Container(
            width: 400,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(30)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(doc["name"], style: TextStyle(color: Colors.white)),
                  Text(doc["date joined"],
                      style: TextStyle(color: Colors.white))
                ])))
        .toList();
  }
}
