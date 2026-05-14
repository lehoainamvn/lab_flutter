import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/catalog_model.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/my_list_item.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Consumer<CatalogModel>(
        builder: (context, catalog, child) {
          return ListView.builder(
            itemCount: catalog.itemCount,
            itemBuilder: (context, index) {
              final item = catalog.getByPosition(index);
              return MyListItem(index: index, item: item);
            },
          );
        },
      ),
    );
  }
}
