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
  Widget build(BuildContext context, WidgetRef ref) => Container(
      decoration: RoundedCornerContainer.containerStyle,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(flex: 1, child: CompanyInfo(entityId)),
            Divider(),
            // ListIndexing(entityId),
            Divider(),
            //Timeline(entityId),
            /*Expanded(
              flex: 10,
              child: EntityList(entityId),
            ),*/
            //DataExportButton(entityId),
            Expanded(
                flex: 10,
                child: SingleChildScrollView(
                  child: EntityListView(entityId, selectedItem),
                )),
            Divider(),
            ListCount(entityId),
          ]));
}
