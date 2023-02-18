import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/providers/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

const totalShares = 60;

class ShareAllocationWidget extends StatefulWidget {
  @override
  _ShareAllocationWidgetState createState() => _ShareAllocationWidgetState();
}

class _ShareAllocationWidgetState extends State<ShareAllocationWidget> {
  final firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> ownerAndShareCount = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final data = await firestore.collection('company/1111/shares').get();
    data.docs.forEach((doc) {
      ownerAndShareCount.add({
        'name': doc.data()['owner'],
        'shares': doc.data()['shareCount'],
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Text('Shares'),
          ...ownerAndShareCount
              .map((data) => ListTile(
                    title: Text(data['name']),
                    subtitle: Text(
                        '${data['shares'].toString()} (%${(data['shares'] * 100 / totalShares).toStringAsFixed(2)})'),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
