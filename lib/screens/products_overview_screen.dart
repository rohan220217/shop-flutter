import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../widgets/main-drawer.dart';

import '../providers/products.dart';
import '../widgets/product_grid.dart';
import '../providers/cart.dart';

enum filterOption { favourite, all }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavourite = false;
  var _didChange = true;
  // @override
  // void initState() {
  //   Provider.of<Products>(context).fetchAndSetProduct(); WOnt work because context is not available in initState we can use didchange...
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_didChange) {
      Provider.of<Products>(context).fetchAndSetProduct();
    }
    _didChange = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Shop'),
          actions: [
            FlatButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/user-products'),
              child: Text(
                'Admin',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            Consumer<Cart>(
              builder: (context, value, child) => FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/cart');
                },
                child: Stack(
                  children: <Widget>[
                    Icon(Icons.shopping_cart),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '${value.itemCount.toString()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            PopupMenuButton(
              onSelected: (filterOption selectedValue) {
                setState(() {
                  if (selectedValue == filterOption.favourite) {
                    _showFavourite = true;
                    // productContainer.showFavouriteOnly();
                  } else {
                    _showFavourite = false;
                    // productContainer.showAllOnly();
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('My favourite'),
                  value: filterOption.favourite,
                ),
                PopupMenuItem(
                  child: Text('Show all'),
                  value: filterOption.all,
                ),
              ],
            ),
          ],
        ),
        body: ProductGrid(_showFavourite));
  }
}
