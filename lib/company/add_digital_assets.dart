import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'company_info.dart';


class AddDigitalAssetsDialog extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _SelectedValueState();
  }
}


class _SelectedValueState extends State<AddDigitalAssetsDialog> {
    
    var assetTitles = ["LinkedIn", "Facebook", "Twitter"];
    var _currentAssetTitle;
    var _formData = { 
      "asset_type" : " ", 
      "asset_url" : " "
     };

    // Hardcoded for testing
    // ISSUE #4
    // Fetch the document ID of currently selected document
     static const _documentId = "123"; 

  
  
  @override
  Widget build(BuildContext context) {
    return Container( 
      margin: EdgeInsets.all(40),
      child : ElevatedButton(
        clipBehavior: Clip.none,
        child: Container(
          child : const Text("Add Digital Assets here")),
        onPressed: (){
                  showDialog(context: context, builder: (context) {
                    return SimpleDialog(
                      children: [Form(child: Column(
                              children: [
                                DropdownButton(
                                    items: assetTitles.map((item) {
                                return DropdownMenuItem(
                                  value: item, 
                                  child: Text(item));
                              }).toList(),
                              
                              // State changes only after quitting the dialog box
                              // ISSUE #1
                              onChanged: (current){
                              setState(() {
                                  this._currentAssetTitle = current.toString();
                                  this._formData["asset_type"] = current.toString();
                                });
                                print(current);
                              },
                              value: _currentAssetTitle,
                              ),
                              TextFormField(
                                onChanged: ((value) {
                                  setState(() {
                                  this._formData["asset_url"] = value;    
                                  });
                                  print(this._formData["asset_url"]);
                                }
                              )),
                              ElevatedButton(
                                onPressed: (){
                                  print(_formData);
                                  FirebaseFirestore.instance.
                                  collection('company').doc(_documentId).collection('asset').add({
                                    "type" : _formData["asset_type"],
                                    "url" : _formData["asset_url"]
                                });
                                }, 
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green
                                ),
                                child: const Text("Save")
                                )
                          ],
                          
                     )
                  )]
                  );
                  }
                );
              })

    );
        }
}

