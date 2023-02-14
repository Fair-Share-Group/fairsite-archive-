import 'dart:convert';
import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login/login.dart';
import 'dart:async';
import '../providers/firestore.dart';
import 'package:fairsite/common.dart';
import 'package:jiffy/jiffy.dart';

class MemberArea extends ConsumerWidget {
  final String companyId;
  MemberArea(this.companyId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('company/$companyId/member/${CURRENT_USER.uid}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (memberDoc) => memberDoc.exists
              ? Column(children: [
                  Text("MEMBER AREA FOR USER ${CURRENT_USER.displayName}",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  buildMemberPanel(context, ref)
                ])
              : Text('uid ${CURRENT_USER.uid} is not a member of $companyId'));

  Widget buildMemberPanel(BuildContext context, WidgetRef ref) {
    return Container(
        child: ref.watch(colSP('company/$companyId/member')).when(
            loading: () => Container(),
            data: (memberDocs) {
              return Column(
                  children: memberDocs.docs.map((doc) {
                return ListTile(
                    title: Text(doc.data()['name']),
                    subtitle: Text(
                        "Date Joined : ${Jiffy(doc.data()['date joined'].toDate()).format("do MMMM yyyy, h:mm:ss a")}"));
              }).toList());
            },
            error: ((error, stackTrace) => ErrorWidget(error))));
  }

  /* List<Widget> getMembers(memberDoc) {
    return memberDoc.map<Widget>((doc) {
      ListTile(title: Text(doc["name"]), subtitle: Text(doc["date joined"]));
    }).toList();
  } */
}


// Stream Builder Code

/* StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("company/$companyId/member")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text("No members found");
                return Column(children: getMembers(snapshot).toList());
              }) */