import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/firestore.dart';
import 'package:fairsite/common.dart';
import '../member/member_area.dart';

class AdminArea extends ConsumerWidget {
  final String companyId;
  AdminArea(this.companyId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('company/$companyId/admin/${CURRENT_USER.uid}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (adminDoc) => adminDoc.exists
              ? buildAdminPanel(ref) //Text("ADMIN PANEL GOES HERE!")
              : Text('uid ${CURRENT_USER.uid} is not an admin of $companyId'));

  Widget buildAdminPanel(WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(children: const [
        ListTile(
          title: Text("Admin privilges"),
          subtitle: Text(" Details of admin privileges go here"),
        ),
        ListTile(
          title: Text("Member Area"),
          subtitle:
              Text(" Member list with options to edit and delete members"),
        ),
        ListTile(
            title: Text("Member modification optionsss"),
            subtitle: Text("Ability to add a member")),
      ]),
    );
  }
}
