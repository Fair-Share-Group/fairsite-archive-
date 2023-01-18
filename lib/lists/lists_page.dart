import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/app_bar.dart';
import 'package:fairsite/lists/lists_list.dart';
import 'package:fairsite/lists/list_details.dart';
import 'package:fairsite/state/generic_state_notifier.dart';
import 'package:fairsite/drawer.dart';
import 'package:fairsite/common.dart';
// import '../controls/custom_json_viewer.dart';
// import 'package:flutter_json_viewer/flutter_json_viewer.dart';

final activeList =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

final selectedItem =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class ListsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
            ? TheDrawer.buildDrawer(context)
            : null,
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                    children: [
                      Lists(),
                    ],
                  ))),
                  Expanded(
                    child: ref.watch(activeList) == null
                        ? Container()
                        : ListDetails(
                            ref.watch(activeList)!, selectedItem.notifier),
                  ),
                  Expanded(
                      child: Card(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ref.watch(selectedItem) == null
                                      ? Container()
                                      : Text(ref.watch(selectedItem)!)
                                  //JsonViewer(ref.watch(selectedItem))

                                  )
                            ],
                          ),
                        ))
                      ])))
                ])));
  }
}
