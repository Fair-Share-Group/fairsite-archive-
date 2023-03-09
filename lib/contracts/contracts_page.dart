import 'dart:html';

import 'package:fairsite/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_bar.dart';
import '../drawer.dart';
import '../providers/firestore.dart';
import 'contract_page.dart';

class ContractsPage extends ConsumerWidget {
  const ContractsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
            ? TheDrawer.buildDrawer(context)
            : null,
        body: Column(children: [
          Text('contracts'),
          ref.watch(colSP('contract')).when(
              data: (data) => Column(
                  children: data.docs
                      .map((e) => TextButton(
                          onPressed: () {
                            //ref.read(selectedItem).state = e.id;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContractPage(e.id)));
                          },
                          child: Text(e.id)))
                      .toList()),
              loading: () => Text('loading'),
              error: (e, s) => Text('error: $e')),
          ElevatedButton(
              onPressed: () {
                DB.collection('contract').add({'name': 'New contract'});
              },
              child: Text('Add contract'))
        ]));
  }
}
