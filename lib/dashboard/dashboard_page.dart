import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/app_bar.dart';
import 'package:fairsite/common.dart';
import 'package:fairsite/dashboard/company_details.dart';
import 'package:fairsite/dashboard/companies_list.dart';
import 'package:fairsite/state/generic_state_notifier.dart';
import 'package:fairsite/drawer.dart';
import 'package:http/http.dart' as http;

final activeBatch =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class DashboardPage extends ConsumerWidget {
  final TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: MyAppBar.getBar(context, ref),
      drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
          ? TheDrawer.buildDrawer(context)
          : null,
      body: Container(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Expanded(
              //         child: TextField(
              //             style: Theme.of(context).textTheme.headline3,
              //             onChanged: (v) {},
              //             controller: searchCtrl)),
              //     ElevatedButton(
              //         child: Text(
              //           "Add",
              //           style: Theme.of(context).textTheme.headline3,
              //         ),
              //         onPressed: () async {
              //           if (searchCtrl.text.isEmpty) return;

              //           // var url = Uri.parse(
              //           //     'https://screen-od6zwjoy2a-an.a.run.app/?name=${searchCtrl.text.toLowerCase()}');
              //           // var response = await http.post(url, body: {
              //           //   // 'name': 'doodle',
              //           //   // 'color': 'blue'
              //           // });
              //           // print(
              //           //     'Response status: ${response.statusCode}');
              //           // print('Response body: ${response.body}');

              //           // FirebaseFirestore.instance
              //           //     .collection('search')
              //           //     .doc(searchCtrl.text)
              //           //     .set({
              //           //   'target': searchCtrl.text,
              //           //   'timeCreated':
              //           //       FieldValue.serverTimestamp(),
              //           //   'author': FirebaseAuth
              //           //       .instance.currentUser!.uid,
              //           // });

              //           fetchAlbum(searchCtrl.text);

              //           FirebaseFirestore.instance.collection('company')
              //               // .doc(FirebaseAuth
              //               //     .instance.currentUser!.uid)
              //               // .collection('search')
              //               .add({
              //             'url': searchCtrl.text,
              //             'timeCreated': FieldValue.serverTimestamp(),
              //             'author': FirebaseAuth.instance.currentUser!.uid,
              //           });
              //         })
              //   ],
              // ),
              Expanded(child: CompaniesList()),
            ],
          )),
    );
  }

  dynamic fetchAlbum(String url) async {
    print('fetching ${url}');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('fail');
      throw Exception('Failed to load album');
    }
  }
}

// buildAddBatchButton(BuildContext context, WidgetRef ref) {
//   TextEditingController id_inp = TextEditingController();
//   TextEditingController name_inp = TextEditingController();
//   TextEditingController desc_inp = TextEditingController();
//   return ElevatedButton(
//     child: Text("Add Batch"),
//     onPressed: () {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               scrollable: true,
//               title: Text('Adding Batch...'),
//               content: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Form(
//                   child: Column(
//                     children: <Widget>[
//                       TextFormField(
//                         controller: id_inp,
//                         decoration: InputDecoration(labelText: 'ID'),
//                       ),
//                       TextFormField(
//                         controller: name_inp,
//                         decoration: InputDecoration(
//                           labelText: 'Name',
//                         ),
//                       ),
//                       TextFormField(
//                         controller: desc_inp,
//                         decoration: InputDecoration(
//                           labelText: 'Description',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                     child: Text("Submit"),
//                     onPressed: () {
//                       FirebaseFirestore.instance.collection('batch').add({
//                         'id': id_inp.text.toString(),
//                         'name': name_inp.text.toString(),
//                         'desc': desc_inp.text.toString(),
//                         'time Created': FieldValue.serverTimestamp(),
//                         'author': FirebaseAuth.instance.currentUser!.uid,
//                       }).then((value) => {
//                             if (value != null)
//                               {FirebaseFirestore.instance.collection('batch')}
//                           });

//                       Navigator.of(context).pop();
//                     })
//               ],
//             );
//           });
//     },
//   );
// }

