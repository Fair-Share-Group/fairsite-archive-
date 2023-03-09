import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/company/company_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:fairsite/controls/doc_field_text_edit.dart';
import 'package:fairsite/company/company_list_page.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'asset_list.dart';
import 'add_digital_assets.dart';

class CompanyInfo extends ConsumerWidget {
  final String entityId;
  const CompanyInfo(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('company/${entityId}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (companyDoc) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(flex: 1, child: CompanyLogo(entityId)),
                    Flexible(
                        flex: 1,
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                  child: Text(
                                (companyDoc.data()!['name'] != null)
                                    ? companyDoc.data()!['name']
                                    : 'no name',
                              )),
                              Flexible(
                                  child: Text(
                                (companyDoc.data()!['founded'] != null)
                                    ? timeago.format((companyDoc
                                            .data()!['founded'] as Timestamp)
                                        .toDate())
                                    : 'no founded date',
                              )),
                              // Flexible(
                              //     child: Text('Last updated: ' +
                              //         Jiffy(entityDoc.data()!['lastUpdateTime'] == null
                              //                 ? DateTime(0001, 1, 1, 00, 00)
                              //                 : entityDoc
                              //                     .data()!['lastUpdateTime']
                              //                     .toDate())
                              //             .format())),
                              // Flexible(
                              //     child: Text('Last changed: ' +
                              //         Jiffy(entityDoc.data()!['lastUpdateTime'] == null
                              //                 ? DateTime(0001, 1, 1, 00, 00)
                              //                 : entityDoc
                              //                     .data()!['lastUpdateTime']
                              //                     .toDate())
                              //             .format())),
                            ])),
                    // Added the dialog here for testing
                    // Issue with overflow is making the button unclickable
                    // ISSUE #2

                    Flexible(flex: 1, child: AddDigitalAssetsDialog()),

                    Flexible(flex: 5, child: AssetListView(entityId)),

                    // Adding a floating point button to add digital assets for a company
                  ]));
}
