import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DocMultilineTextField extends ConsumerStatefulWidget {
//   final DocumentReference<Map<String, dynamic>> docRef;
//   final String field;
//   final InputDecoration? decoration;
//   final int maxLines;

//   final TextEditingController ctrl = TextEditingController();

//   DocMultilineTextField(this.docRef, this.field, this.maxLines,
//       {this.decoration, Key? key})
//       : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       DocMultilineTextFieldState();
// }

// class DocMultilineTextFieldState extends ConsumerState<DocMultilineTextField> {
//   Timer? descSaveTimer;
//   StreamSubscription? sub;

//   @override
//   void initState() {
//     super.initState();
//     sub = widget.docRef.snapshots().listen((event) {
//       if (!event.exists) return;
//       print('received ${event.data()![widget.field]}');
//       if (widget.ctrl.text != event.data()![widget.field]) {
//         widget.ctrl.text = event.data()![widget.field];
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     if (sub != null) {
//       print('sub cancelled');
//       sub!.cancel();
//       sub = null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // return ref
//     //     .watch(docSPdistinct(DocParam(widget.docRef.path, (prev, curr) {
//     //       //print('equals called');
//     //       if (prev.data()![widget.field] == curr.data()![widget.field]) {
//     //         // print('field ${field} did not change, return true');
//     //         return true;
//     //       }
//     //       if (widget.ctrl.text == curr.data()![widget.field]) {
//     //         return true;
//     //       }
//     //       // print(
//     //       //     'field changed! ctrl: ${widget.ctrl.text}!=${curr.data()![widget.field]}');
//     //       return false;
//     //     })))
//     //     .when(
//     //         loading: () => Container(),
//     //         error: (e, s) => ErrorWidget(e),
//     //         data: (docSnapshot) {
//     return TextField(
//       maxLines: widget.maxLines,
//       decoration: widget.decoration,
//       controller:
//           widget.ctrl, //..text = docSnapshot.data()![widget.field] ?? '',
//       onChanged: (v) {
//         if (descSaveTimer != null && descSaveTimer!.isActive) {
//           descSaveTimer!.cancel();
//         }
//         descSaveTimer = Timer(Duration(milliseconds: 200), () {
//           // if (docSnapshot.data() == null ||
//           //     v != docSnapshot.data()![widget.field]) {
//           Map<String, dynamic> map = {};
//           map[widget.field] = v;
//           // the document will get created, if not exists
//           widget.docRef.set(map, SetOptions(merge: true));
//           // throws exception if document doesn't exist
//           //widget.docRef.update({widget.field: v});
//           // }
//         });
//       },
//       // onSubmitted: (v) {
//       //   if (descSaveTimer != null && descSaveTimer!.isActive) {
//       //     descSaveTimer!.cancel();
//       //   }
//       //   descSaveTimer = Timer(Duration(milliseconds: 200), () {
//       //     // if (docSnapshot.data() == null ||
//       //     //     v != docSnapshot.data()![widget.field]) {
//       //     Map<String, dynamic> map = {};
//       //     map[widget.field] = v;
//       //     // the document will get created, if not exists
//       //     widget.docRef.set(map, SetOptions(merge: true));
//       //     // throws exception if document doesn't exist
//       //     //widget.docRef.update({widget.field: v});
//       //     // }
//       //   });
//       // },
//     );
//     // });
//   }
// }

class DocMultilineTextField extends ConsumerStatefulWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;
  final InputDecoration? decoration;
  final int maxLines;

  DocMultilineTextField(this.docRef, this.field, this.maxLines,
      {this.decoration, Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      DocMultilineTextFieldState();
}

class DocMultilineTextFieldState extends ConsumerState<DocMultilineTextField> {
  Timer? descSaveTimer;
  StreamSubscription? sub;
  final TextEditingController ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    sub = widget.docRef.snapshots().listen((event) {
      if (!event.exists) return;
      print('received ${event.data()![widget.field]}');
      if (ctrl.text != event.data()![widget.field]) {
        ctrl.text = event.data()![widget.field];
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (sub != null) {
      sub!.cancel();
      sub = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // return ref
    //     .watch(docSPdistinct(DocParam(widget.docRef.path, (prev, curr) {
    //       //print('equals called');
    //       if (prev.data()![widget.field] == curr.data()![widget.field]) {
    //         // print('field ${field} did not change, return true');
    //         return true;
    //       }
    //       if (widget.ctrl.text == curr.data()![widget.field]) {
    //         return true;
    //       }
    //       // print(
    //       //     'field changed! ctrl: ${widget.ctrl.text}!=${curr.data()![widget.field]}');
    //       return false;
    //     })))
    //     .when(
    //         loading: () => Container(),
    //         error: (e, s) => ErrorWidget(e),
    //         data: (docSnapshot) {
    return TextField(
      maxLines: widget.maxLines,
      decoration: widget.decoration,
      controller: ctrl, //..text = docSnapshot.data()![widget.field] ?? '',
      onChanged: (v) {
        if (descSaveTimer != null && descSaveTimer!.isActive) {
          descSaveTimer!.cancel();
        }
        descSaveTimer = Timer(Duration(milliseconds: 2000), () {
          // if (docSnapshot.data() == null ||
          //     v != docSnapshot.data()![widget.field]) {
          Map<String, dynamic> map = {};
          map[widget.field] = v;
          // the document will get created, if not exists
          widget.docRef.set(map, SetOptions(merge: true));
          // throws exception if document doesn't exist
          //widget.docRef.update({widget.field: v});
          // }
        });
      },
      // onSubmitted: (v) {
      //   if (descSaveTimer != null && descSaveTimer!.isActive) {
      //     descSaveTimer!.cancel();
      //   }
      //   descSaveTimer = Timer(Duration(milliseconds: 200), () {
      //     // if (docSnapshot.data() == null ||
      //     //     v != docSnapshot.data()![widget.field]) {
      //     Map<String, dynamic> map = {};
      //     map[widget.field] = v;
      //     // the document will get created, if not exists
      //     widget.docRef.set(map, SetOptions(merge: true));
      //     // throws exception if document doesn't exist
      //     //widget.docRef.update({widget.field: v});
      //     // }
      //   });
      // },
    );
    // });
  }
}
