import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fairsite/main.dart';

class ThemeStateNotifier extends StateNotifier<bool> {
  ThemeStateNotifier(bool loginState) : super(false) {
    if (loginState == true && AUTH.currentUser != null) {
      DB
          .collection('user')
          .doc(AUTH.currentUser!.uid)
          .get()
          .then((value) {
        String theme = value['themeMode'];
        bool isDark = theme == 'light' ? false : true;
        state = isDark;
      });
    }
  }
  void changeTheme() {
    state = !state;
    String themeMode = state == false ? 'light' : 'dark';
    if (AUTH.currentUser != null) {
      DB
          .collection('user')
          .doc(AUTH.currentUser!.uid)
          .set({'themeMode': themeMode});
    }
  }
}

final themeStateNotifierProvider =
    StateNotifierProvider<ThemeStateNotifier, bool>((ref) {
  bool loginState = ref.watch(isLoggedIn);
  return ThemeStateNotifier(loginState);
}, dependencies: [isLoggedIn]);