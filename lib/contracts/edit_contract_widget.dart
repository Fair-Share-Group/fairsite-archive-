import 'dart:html';

import 'package:fairsite/controls/doc_field_text_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_bar.dart';
import '../common.dart';
import '../drawer.dart';
import '../state/generic_state_notifier.dart';

class EditContractWidget extends ConsumerWidget {
  final String docId;
  final editModeSNP = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
      (ref) => GenericStateNotifier<bool>(false));

  EditContractWidget(this.docId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
        children: [DocFieldTextEdit2(DB.doc('contract/$docId'), 'text')]);
  }
}
