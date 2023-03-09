import 'package:fairsite/common.dart';
import 'package:fairsite/company/asset/website_asset_widget.dart';
import 'package:fairsite/company/asset/facebook_asset_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:fairsite/company/company_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fairsite/state/generic_state_notifier.dart';

import 'asset/abn_asset_widget.dart';
import 'asset/linkedin_asset_widget.dart';
import 'asset/twitter_asset_widget.dart';

class AssetListView extends ConsumerWidget {
  final String entityId;
  // final AlwaysAliveProviderBase<GenericStateNotifier<Map<String, dynamic>?>>
  //     selectedItem;

  const AssetListView(this.entityId
      //, this.selectedItem
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: ref.watch(colSP('company/$entityId/asset')).when(
            loading: () => [],
            error: (e, s) => [ErrorWidget(e)],
            data: (entities) => entities.docs.map<Widget>((entityDoc) {
                  try {
                    final type = AssetType.values.byName(data(entityDoc, 'type').toString());
                    switch (type) {
                      case AssetType.LinkedIn:
                        return LinkedInAssetWidget(entityDoc.reference);
                      case AssetType.Twitter:
                        return TwitterAssetWidget(entityDoc.reference);
                      case AssetType.Facebook:
                        return FacebookAssetWidget(entityDoc.reference);
                      case AssetType.ABN:
                        return ABNAssetWidget(entityDoc.reference);
                      case AssetType.Website:
                        return WebsiteAssetWidget(entityDoc.reference);
                    } 
                  } catch(e) {
                    print("Ran into exception when trying to cast ${data(entityDoc, 'type')} to AssetType");
                    print(e);
                    return Text('${data(entityDoc, 'type').toString()} is not a valid asset type');
                  }
                }).toList()));
  }
}