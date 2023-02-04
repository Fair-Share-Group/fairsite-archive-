import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FacebookAssetWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
      title: Text('Facebook'),
      subtitle: Text(''),
      isThreeLine: true,
      trailing: IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          //API Call...
        },
      ),
      onTap: () {
        // ref.read(selectedItem).value = Map.fromEntries(
        //     entity.data().entries.toList()
        //       ..sort((e1, e2) => e1.key.compareTo(e2.key)));
      });
}
