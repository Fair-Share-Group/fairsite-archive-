import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/firestore.dart';

class MemberArea extends ConsumerWidget {
  final String companyId;
  MemberArea(this.companyId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(docSP(
          'company/$companyId/member/${FirebaseAuth.instance.currentUser!.uid}'))
      .when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (memberDoc) => memberDoc.exists
              ? Text('member area')
              : Text(
                  'uid ${FirebaseAuth.instance.currentUser!.uid} is not a member of ${companyId}'));
}
