import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairsite/common.dart';
import 'package:fairsite/company/company_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'company_info.dart';

class AddDigitalAssetsDialog extends ConsumerStatefulWidget {
  
  @override
  ConsumerState<AddDigitalAssetsDialog> createState() {
    return _SelectedValueState();
  }
}

class _SelectedValueState extends ConsumerState<AddDigitalAssetsDialog> {
  var _currentAssetTitle;

  var _formData = {"asset_type": "", "asset_id": ""};

  @override
  Widget build(BuildContext context) {
    final _entityId = ref.watch(activeList);

    return Container(
        margin: EdgeInsets.all(0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            clipBehavior: Clip.none,
            child: Container(
                padding: EdgeInsets.all(5), child: const Text("Add Asset")),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                        contentPadding: EdgeInsets.all(20),
                        children: [
                          Form(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: "Asset type: ",
                                    contentPadding: EdgeInsets.all(20)),
                                items: AssetType.values.map((item) {
                                  return DropdownMenuItem(
                                      value: item.name, child: Text(item.name));
                                }).toList(),
                                onSaved: (current) {
                                  this._currentAssetTitle = current.toString();
                                },
                                onChanged: (current) async {
                                  setState(() {
                                    this._currentAssetTitle =
                                        current.toString();
                                    this._formData["asset_type"] =
                                        current.toString();
                                  });
                                },
                                value: this._currentAssetTitle,
                              ),
                              TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Asset ID:",
                                      contentPadding: EdgeInsets.all(20)),
                                  onChanged: ((value) {
                                    setState(() {
                                      this._formData["asset_id"] = value.trim();
                                    });
                                  })),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formData.values.contains('')) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Fields cannot be empty")));
                                      return;
                                    }

                                    DB
                                        .collection('company')
                                        .doc(_entityId)
                                        .collection('asset')
                                        .add({
                                      "type": _formData["asset_type"],
                                      "id": _formData["asset_id"]
                                    }).whenComplete(() {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Asset successfully added to $_entityId")));
                                      Navigator.pop(context);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      padding: EdgeInsets.all(20)),
                                  child: const Text("Save"))
                            ],
                          ))
                        ]);
                  });
            }));
  }
}
