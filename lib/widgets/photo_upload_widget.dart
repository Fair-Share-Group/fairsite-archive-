// import 'dart:async';
// import 'dart:html' as html;
// import 'dart:html';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'dart:typed_data';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// const double PHOTO_RADIUS = 50;
// const String BUCKET_PATH_USR = "user_resume";

// class PhotoUploadWidget extends ConsumerWidget {

//   final String 

//   PhotoUploadWidget();

//   // final TextEditingController _name = TextEditingController();
//   // final FocusNode _nameFocus = FocusNode();

//   final profilePhotoUploadStateProvider =
//       StateNotifierProvider((ref) => FileUploadNotifier());

//   @override
//   Widget build(BuildContext context, WidgetRef ref) => Column(children: [
//         Flexible(
//             child: GestureDetector(
//                 //child: Container(),
//                 child: (ref.watch(profilePhotoUploadStateProvider) == null ||
//                         ref.watch(profilePhotoUploadStateProvider) ==
//                             TaskState.success)
//                     ? buildPhoto(context, ref)
//                     : (ref.watch(profilePhotoUploadStateProvider) ==
//                             TaskState.running
//                         ? Center(child: CircularProgressIndicator())
//                         : Container()),
//                 onTap: () async {
//                   html.InputElement uploadInput =
//                       html.FileUploadInputElement() as InputElement;

//                   uploadInput.onChange.listen((e) async {
//                     // read file content as dataURL
//                     final files = uploadInput.files!;
//                     if (files.length == 1) {
//                       final file = files[0];
//                       html.FileReader reader = html.FileReader();

//                       reader.onLoadEnd.listen((e) async {
//                         // print("wrote bytes");

//                         UploadTask _uploadTask;
//                         _uploadTask = FirebaseStorage.instance
//                             .ref()
//                             .child(BUCKET_PATH_USR +
//                                 FirebaseAuth.instance.currentUser!.uid +
//                                 '.jpeg')
//                             .putData(
//                                 reader.result as Uint8List,
//                                 SettableMetadata(
//                                   cacheControl: 'public,max-age=31536000',
//                                   contentType: 'image/jpeg',
//                                 ));

//                         _uploadTask.catchError((error) {
//                           print('photo storage error');
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text(error.toString())));
//                         });

//                         // print('set upload task notifier');
//                         ref
//                             .read(profilePhotoUploadStateProvider.notifier)
//                             .uploadTask = _uploadTask;

//                         final TaskSnapshot downloadUrl = (await _uploadTask);

//                         final String url =
//                             (await downloadUrl.ref.getDownloadURL());

//                         await FirebaseStorage.instance
//                             .ref()
//                             .child(BUCKET_PATH_USR +
//                                 FirebaseAuth.instance.currentUser!.uid +
//                                 '.jpeg')
//                             .updateMetadata(SettableMetadata(
//                                 cacheControl: 'public,max-age=31536000',
//                                 contentType: 'image/jpeg',
//                                 customMetadata: {}));

//                         FirebaseFirestore.instance
//                             .doc(
//                                 'userInfo/${FirebaseAuth.instance.currentUser!.uid}')
//                             .update({"photoUrl": url});
//                       });

//                       reader.onError.listen((Object error) {
//                         print('photo read error: ${error.toString()}');
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(error.toString())));
//                       });

//                       reader.readAsArrayBuffer(file);
//                     }
//                   });
//                   uploadInput.click();
//                 }))
//       ]);

//   Widget buildPhoto(BuildContext context, WidgetRef ref) => Center(
//       child: ref
//           .watch(docSP('userInfo/${FirebaseAuth.instance.currentUser!.uid}'))
//           .when(
//             loading: () => Container(),
//             error: (e, s) => ErrorWidget(e),
//             data: (userInfo) => CircleAvatar(
//                 radius: 50,
//                 backgroundImage: userInfo.exists &&
//                         !(userInfo.data()?['photoUrl'] ?? '').isEmpty
//                     ? Image.network(userInfo.data()!['photoUrl'],
//                             width: 50, height: 50)
//                         .image
//                     : (FirebaseAuth.instance.currentUser?.photoURL == null
//                         ? Image.asset(PERSON_IMG).image
//                         : Image.network(
//                                 FirebaseAuth.instance.currentUser!.photoURL!)
//                             .image)),
//           ));
//   // ref.watch(docStreamProvider('org/$uid')).when(
//   //     data: (org) => org.data() == null || org.data()!['logoUrl'] == null
//   //         ? Center(
//   //             child: ClipOval(
//   //                 child: Container(
//   //                     height: PHOTO_RADIUS * 2,
//   //                     width: PHOTO_RADIUS * 2,
//   //                     color: Colors.grey.shade200,
//   //                     child: Image.asset(BLANK_PHOTO_URL,
//   //                         width: PHOTO_RADIUS * 2,
//   //                         height: PHOTO_RADIUS * 2,
//   //                         fit: BoxFit.cover))))
//   //         : Container(
//   //             width: PROFILE_PHOTO_WIDTH,
//   //             height: PROFILE_PHOTO_WIDTH,
//   //             child: CircleAvatar(
//   //                 backgroundImage:
//   //                   Image.asset(PERSON_IMG).image
//   //                   //NetworkImage(org.data()!['logoUrl']),
//   //                 backgroundColor: Colors.transparent,
//   //                 radius: PHOTO_RADIUS)),
//   //     loading: () => Text('loading...'),
//   //     error: (e, s) => ErrorWidget(e));
// }

// class FileUploadNotifier extends StateNotifier<TaskState?> {
//   FileUploadNotifier() : super(null);

//   StreamSubscription<TaskSnapshot>? _tickerSubscription;

//   late UploadTask _uploadTask;
//   set uploadTask(t) {
//     _uploadTask = t;

//     if (t == null) {
//       return;
//     }

//     if (_tickerSubscription != null) _tickerSubscription!.cancel();

//     state = TaskState.running;

//     _tickerSubscription = _uploadTask.asStream().listen((event) {
//       // print('upload state $event');
//       state = event.state;
//     }, onError: (error) {
//       print('upload error $error');
//     }, onDone: () {
//       // print('upload done!');
//       if (_tickerSubscription != null) _tickerSubscription!.cancel();
//     }, cancelOnError: true);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
