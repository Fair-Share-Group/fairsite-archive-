import 'package:fairsite/member/contract_widget.dart';
import 'package:fairsite/member/shares_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              ? Column(
                  children: [
                    Text('member area'),
                    ContractWidget(companyId),
                    SharesWidget(companyId)
                  ],
                )
              : Text(
                  'uid ${CURRENT_USER.uid} is not a member of ${companyId}'));
}
