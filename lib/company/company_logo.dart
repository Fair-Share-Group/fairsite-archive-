import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:fairsite/controls/doc_field_text_edit.dart';
import 'package:fairsite/company/company_list_page.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'asset_list.dart';
import 'add_digital_assets.dart';

class CompanyLogo extends ConsumerWidget {
  final String entityId;
  const CompanyLogo(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('company/${entityId}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (companyDoc) =>
              Image(image: NetworkImage(companyDoc.data()!['logoUrl'] ?? '')));
}
