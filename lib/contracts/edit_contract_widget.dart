import 'dart:convert';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/controls/doc_field_text_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../app_bar.dart';
import '../common.dart';
import '../controls/doc_multiline_text_field.dart';
import '../drawer.dart';
import '../providers/firestore.dart';
import '../state/generic_state_notifier.dart';

class EditContractWidget extends ConsumerWidget {
  final DS docId;
  final editModeSNP = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
      (ref) => GenericStateNotifier<bool>(false));

  EditContractWidget(this.docId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      Text('Edit contract ${docId}'),
      DocFieldTextEdit2(DB.doc('contract/$docId'), 'text'),
      ref.watch(docFP(docId.reference.path)).when(
          data: (data) => Text("id: ${data.data()!['name']}"),
          loading: () => Text('loading'),
          error: (e, s) => Text('error $e')),
      DocFieldTextEdit2(docId.reference, 'name',
          decoration: InputDecoration(label: Text('Cell Name'))),
      DocMultilineTextField(docId.reference, 'prompt', 5),
      ElevatedButton(
          onPressed: () async {
            docId.reference.get().then((doc) async {
              print(doc.data());
              if (doc.data()?['prompt'] != null) {
                final userId = kUSR!.uid;
                print(
                    'generate code for ${doc.data()?['prompt']}, uid: ${userId}');

                kDB.doc('user/${userId}').get().then((userDoc) async {
                  final http.Response response = await http.post(
                      Uri.parse('https://api.openai.com/v1/completions'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization':
                            'Bearer ${userDoc.data()?['openai_key']}'
                      },
                      body: jsonEncode({
                        'model': 'text-davinci-003',
                        'prompt': '${doc.data()?['prompt']}',
                        //'"""\n${doc.data()?['prompt']}\n"""',
                        'max_tokens': 500,
                        'temperature': 0,
                        'top_p': 1,
                        'frequency_penalty': 0,
                        'presence_penalty': 0,
                        // 'stop': ["###"],
                        //'n': 1,
                        //'stop': '\n'
                      }));

                  if (response.statusCode == 200) {
                    print(jsonDecode(response.body));
                    docId.reference.update({
                      'code': jsonDecode(response.body)['choices'][0]['text']
                    });
                  } else {
                    print(
                        'Request failed with status: ${response.statusCode} ${response.body}.');
                  }
                });
              }
            });
          },
          child: Text('Generate code')),
      DocMultilineTextField(docId.reference, 'code', 10),
    ]);
  }
}
