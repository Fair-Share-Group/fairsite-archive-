import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

Future<dynamic> _getTwitterData(String username, List<String> fields) async {
  String apiUrl =
      "https://api.twitter.com/2/users/by/username/${username.toLowerCase()}?user.fields=${fields.join(",")}";

  // Require our own CORS wrapper to use Twitter API directly, along with extra
  // security since this exposes API keys. This is only for development purposes
  // and should not be used in production. Everything making use of API keys must
  // be handled by middleware and on the back end and not on the front end like we
  // are doing here.
  String corsWrapperUrl = "https://cors-anywhere.herokuapp.com/";

  final http.Response res = await http.get(
    Uri.parse("$corsWrapperUrl$apiUrl"),
    headers: {
      'Authorization': 'Bearer KEYHERE',
    },
  );

  if (res.statusCode == 404) {
    return "User could not be found";
  }

  if (res.statusCode == 401 || res.statusCode == 403) {
    return "Application is not authenticated";
  }

  var body = jsonDecode(res.body);

  return body;
}

class TwitterAssetWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
        title: Text('Twitter'),
        subtitle: Text('s'),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            _getTwitterData("google", [
              "public_metrics",
              "profile_image_url",
              "created_at"
            ]).then((value) => print(value));
          },
        ),
      );
}
