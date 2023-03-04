import 'package:fairsite/admin/admin_area.dart';
import 'package:fairsite/member/member_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/company/company_info.dart';
import 'package:fairsite/company/list_entitylistview.dart';
import 'package:fairsite/state/generic_state_notifier.dart';
import 'package:fairsite/theme.dart';

import 'list_count.dart';

class CompanyDetails extends ConsumerWidget {
  final String entityId;
  final AlwaysAliveProviderBase<GenericStateNotifier<String?>> selectedItem;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  CompanyDetails(this.entityId, this.selectedItem);

  @override
  Widget build(BuildContext context, WidgetRef ref) => SingleChildScrollView(
      child: Container(
          decoration: RoundedCornerContainer.containerStyle,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(flex: 1, child: CompanyInfo(entityId)),
                Flexible(
                    child: MemberArea(
                        entityId)), // only one area should be shown at a time
                Flexible(child: AdminArea(entityId)),
              ])));
}
