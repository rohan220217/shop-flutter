import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProduct extends StatelessWidget {
  Future<void> _refreshUi(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/edit-product');
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshUi(context),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
                itemCount: productData.items.length,
                itemBuilder: (_, i) => Column(
                      children: [
                        UserProductItem(
                            productData.items[i].id,
                            productData.items[i].title,
                            productData.items[i].imageUrl),
                        Divider(),
                      ],
                    ))),
      ),
    );
  }
}
