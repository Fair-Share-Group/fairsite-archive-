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
    
    var _currentAssetTitle;
    var assetTitles = ["LinkedIn", "Facebook", "Twitter"];
    
    var _formData = { 
      "asset_type" : " ", 
      "asset_url" : " "
     };

    // Hardcoded for testing
    // ISSUE #1
    // Fetch the document ID of currently selected document
     static const _documentId = "1111"; 

  
  
  @override
  Widget build(BuildContext context) {
    return Container( 
      margin: EdgeInsets.all(0),
      child : ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber
        ),
        clipBehavior: Clip.none,
        child: Container(
          padding: EdgeInsets.all(5),
          child : const Text("Add Digital Assets here")),
        onPressed: (){
                  showDialog(context: context, builder: (context) {
                    return SimpleDialog(
                      contentPadding: EdgeInsets.all(20),
                      children: [Form(child: 
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DropdownButtonFormField(
                                    decoration: InputDecoration(labelText: "Choose asset type: ", 
                                    contentPadding: EdgeInsets.all(20)),
                      
                                    items: assetTitles.map((item) {
                                return DropdownMenuItem(
                                  value: item, 
                                  child: Text(item));
                              }).toList(),
                              
                              onSaved: (current) {
                                this._currentAssetTitle = current.toString();
                              },
                              onChanged: (current) async {
                              setState(() {
                                  this._currentAssetTitle = current.toString();
                                  this._formData["asset_type"] = current.toString();
                                });
      
                                print(current);
                              },
                              value: this._currentAssetTitle,
                              ),
                              TextFormField(
                                decoration: InputDecoration(labelText: "Enter asset URL :", 
                                            contentPadding: EdgeInsets.all(20)),
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
                                    
                                    ScaffoldMessenger.of(context).
                                    showSnackBar(
                                      SnackBar(content: Text("Fields cannot be blank")));
                                 
                                    FirebaseFirestore.instance.
                                  collection('company').doc(_documentId).collection('asset').add({
                                    "type" : _formData["asset_type"],
                                    "url" : _formData["asset_url"]
                                });
                                  
                                }, 
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  padding: EdgeInsets.all(20)
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

