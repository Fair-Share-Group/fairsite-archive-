import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/firestore.dart';
import 'package:fairsite/common.dart';

class AdminArea extends ConsumerWidget {
  final String companyId;
  AdminArea(this.companyId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(docSP(
          'company/$companyId/admin/${CURRENT_USER.uid}'))
      .when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (adminDoc) => adminDoc.exists
              ? Text('Admin Area')
              : Text(
                  'uid ${CURRENT_USER.uid} is not an admin of ${companyId}'));
}
