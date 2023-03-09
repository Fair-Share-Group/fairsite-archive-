import 'dart:html';

import 'package:fairsite/contracts/edit_contract_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_bar.dart';
import '../common.dart';
import '../drawer.dart';
import '../state/generic_state_notifier.dart';

class ContractPage extends ConsumerWidget {
  final editModeSNP = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
      (ref) => GenericStateNotifier<bool>(false));

  final String docId;
  ContractPage(this.docId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
            ? TheDrawer.buildDrawer(context)
            : null,
        body: Column(children: [
          Text('contract'),
          showContractText(context, ref),
          switchEditMode(context, ref)
        ]));
  }

  Widget showContractText(BuildContext context, WidgetRef ref) {
    return ref.watch(editModeSNP)
        ? EditContractWidget(docId)
        : Text('show contract');
  }

  Widget switchEditMode(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () {
          ref.read(editModeSNP.notifier).value =
              !ref.read(editModeSNP.notifier).value;
        },
        child: Text(
            '${ref.read(editModeSNP.notifier).value ? 'Show' : 'Edit'} contract'));
  }
}
