import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:fairsite/dashboard/dashboard_page.dart';

import '../controls/doc_field_text_edit.dart';

class CompanyItem extends ConsumerWidget {
  final DocumentReference searchRef;
  // const SearchListItem(this.searchRef);
  final TextEditingController ctrl = TextEditingController();

  CompanyItem(this.searchRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP(searchRef.path)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (searchDoc) => Card(
                child: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Flexible(flex: 1, child: Text('vac ')),
                      Flexible(
                          flex: 1,
                          child: Text(
                            (searchDoc.data()!['name'] ?? ''),
                            style: Theme.of(context).textTheme.headline3,
                          )),
                      //Flexible(flex: 1, child: Text('Applying...')),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text('Job details'),
                              content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    searchDoc
                                        .data()!['positionDesc']
                                        .join("\n"),
                                  )),
                              actions: [
                                TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            );
                          });
                    },
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.delete),
                  //   onPressed: () {
                  //     showDialog(
                  //         context: context,
                  //         builder: (BuildContext context) {
                  //           return AlertDialog(
                  //             scrollable: true,
                  //             title: Text('Delete Sentence...'),
                  //             content: Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Text('Are you sure?')),
                  //             actions: [
                  //               TextButton(
                  //                   child: Text("Yes"),
                  //                   onPressed: () {
                  //                     searchRef.delete();
                  //                     Navigator.of(context).pop();
                  //                   }),
                  //               TextButton(
                  //                   child: Text("Cancel"),
                  //                   onPressed: () {
                  //                     Navigator.of(context).pop();
                  //                   })
                  //             ],
                  //           );
                  //         });
                  //   },
                  // ))
                  //,
                  // subtitle: Text(entityDoc.data()!['desc'] ?? 'desc'),
                  // trailing: Column(children: <Widget>[
                  //   Text(searchDoc.data()!['target'] ?? ''),
                  //   // buildDeleteEntityButton(
                  //   //     context,
                  //   //     FirebaseFirestore.instance
                  //   //         .collection('batch')
                  //   //         .doc(batchId),
                  //   //     Icon(Icons.delete))
                  // ]),
                  onTap: () {
                    ref.read(activeBatch.notifier).value = searchRef.id;
                  },
                )
              ],
            )));
  }
}
