import 'package:fairsite/providers/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/main.dart';
import 'package:fairsite/state/theme_state_notifier.dart';
import 'package:fairsite/common.dart';

class MyAppBar {
  static final List<String> _tabs = [
    'Dashboard',
    // 'lists',
    // 'pep admin',
    // 'pep library',
    // 'adverse media'
  ];

  static PreferredSizeWidget getBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading:
          (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
              ? true
              : false,
      leadingWidth:
          (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH) ? null : 100,
      leading: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
          ? null
          : Padding(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                    Clipboard.setData(ClipboardData(text: CURRENT_USER.uid)).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${CURRENT_USER.uid} copied to clipboard"))
                      );
                    });
                },
                child: Text(
                  'signed in as: ${CURRENT_USER.uid}'),
              )
                  
            ),
      title: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
          ? null
          : Align(
              child: SizedBox(
                  width: 800,
                  child: TabBar(
                    tabs: _tabs
                        .map((t) => Tab(
                            iconMargin: EdgeInsets.all(0),
                            child:
                                // GestureDetector(
                                //     behavior: HitTestBehavior.translucent,
                                //onTap: () => navigatePage(text, context),
                                //child:
                                Text(t.toUpperCase(),
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: TextStyle(
                                        color:
                                            // Theme.of(context).brightness == Brightness.light
                                            //     ? Color(DARK_GREY)
                                            //:
                                            Colors.white))))
                        .toList(),
                    onTap: (index) {
                      Navigator.of(context).pushNamed(_tabs[index]);
                    },
                  ))),
      actions: [
        ThemeIconButton(),
        ref
            .watch(docSP('userInfo/${FirebaseAuth.instance.currentUser?.uid}'))
            .when(
                loading: () => Container(),
                error: (e, s) => ErrorWidget(e),
                data: (userInfo) => GestureDetector(
                    key: Key('edit_user_profile'),
                    onTap: () {
                      showEditProfileDialog(context, ref);
                    },
                    child: Tooltip(
                        message: 'edit profile',
                        child: Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Center(
                                child: CircleAvatar(
                                    radius: 12,
                                    backgroundImage: userInfo.exists &&
                                            !(userInfo.data()?['photoUrl'] ??
                                                    '')
                                                .isEmpty
                                        ? Image.network(
                                                userInfo.data()!['photoUrl'],
                                                width: 50,
                                                height: 50)
                                            .image
                                        : (FirebaseAuth.instance.currentUser
                                                    ?.photoURL ==
                                                null
                                            ? Image.asset('').image
                                            : Image.network(FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .photoURL!)
                                                .image))))))),
        IconButton(
            onPressed: () {
              ref.read(isLoggedIn.notifier).value = false;
              FirebaseAuth.instance.signOut();
              // print("Signed out");
            },
            icon: Icon(Icons.exit_to_app))
      ],
    );
  }

  static void showEditProfileDialog(BuildContext context, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Edit my profile"),
              content: SizedBox(
                  height: 200.0, // Change as per your requirement
                  width: 400.0, // Change as per your requirement
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: FirebaseAuth
                                          .instance.currentUser?.uid));

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Copied UID to clipboard"),
                                  ));
                                },
                                child: Text(
                                    'UID: ${FirebaseAuth.instance.currentUser?.uid}'))),
                        Expanded(child: Text('photo here')
                            //ProfilePhotoEditor()
                            ),
                        // ...ref
                        //     .watch(docSP(
                        //         'userInfo/${FirebaseAuth.instance.currentUser?.uid}'))
                        //     .when(
                        //         data: (userDoc) => [
                        //               Text(userDoc.data()!['email']),
                        //             ],
                        //         loading: () => [CircularProgressIndicator()],
                        //         error: (e, s) => [ErrorWidget(e)])
                      ])),
              actions: <Widget>[
                ElevatedButton(
                    key: Key('sign_out_btn'),
                    child: Text("Sign Out"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      FirebaseAuth.instance.signOut();
                    }),
                ElevatedButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }
}

class ThemeIconButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkState = ref.watch(themeStateNotifierProvider);
    return IconButton(
        tooltip: 'dark/light mode',
        onPressed: () {
          ref.read(themeStateNotifierProvider.notifier).changeTheme();
        },
        icon: Icon(isDarkState == true
            ? Icons.nightlight
            : Icons.nightlight_outlined));
  }
}
