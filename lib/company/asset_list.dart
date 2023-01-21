import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:fairsite/company/company_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fairsite/state/generic_state_notifier.dart';

import '../asset/linkedin_asset_widget.dart';
import '../asset/twitter_asset_widget.dart';

class AssetListView extends ConsumerWidget {
  final String entityId;
  // final AlwaysAliveProviderBase<GenericStateNotifier<Map<String, dynamic>?>>
  //     selectedItem;

  const AssetListView(this.entityId
      //, this.selectedItem
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: ref.watch(colSP('company/$entityId/asset')).when(
              loading: () => [],
              error: (e, s) => [ErrorWidget(e)],
              data: (entities) => entities.docs
                  .map((entityDoc) => entityDoc.data()['type'] == 'LinkedIn'
                      ? LinkedInAssetWidget()
                      : (entityDoc.data()['type'] == 'Twitter'
                          ? TwitterAssetWidget()
                          : Text('no widget')))
                  .toList()))
    ]);
  }
}
