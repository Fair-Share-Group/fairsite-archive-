import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class LinkedInAssetWidget extends ConsumerWidget {
  late String _linkedinData;
  Future<String> _getLinkedinData() async {
    final response = await http.post(
        Uri.parse(
            'https://linkedin-company-data.p.rapidapi.com/linkedInCompanyDataJsonV3Beta?liUrl=https://www.linkedin.com/company/dropbox'),
        headers: {
          'content-type': 'application/json',
          'X-RapidAPI-Key':
              'dd66492e5bmsh44a40c07a96181fp1e3a6djsncc967ec3ba2f',
          'X-RapidAPI-Host': 'linkedin-company-data.p.rapidapi.com'
        }); //Example data (should use the company linkedin url in the uri.parse and the correct API key)
    if (response.statusCode == 200) {
      // print(response.body); to see what the api returns
      return _linkedinData = response.body;
    } else {
      throw Exception("No data found");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
      title: Text('LinkedIn'),
      subtitle: Text('s'),
      isThreeLine: true,
      trailing: IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          _getLinkedinData();
        },
      ),
      onTap: () {
        // ref.read(selectedItem).value = Map.fromEntries(
        //     entity.data().entries.toList()
        //       ..sort((e1, e2) => e1.key.compareTo(e2.key)));
      });
}
