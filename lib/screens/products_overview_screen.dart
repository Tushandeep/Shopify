import 'package:flutter/material.dart' hide Badge;
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../providers/favorite_var.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_gridview.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = '/product-screen';
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  late Future _productFuture;

  Future<void> _fetchData() async {
    return Provider.of<Products>(
      context,
      listen: false,
    ).fetchAndSetProducts();
  }

  @override
  void initState() {
    super.initState();
    _productFuture = _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final favToggle = Provider.of<ShowFavorite>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Shop',
        ),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) {
              return Badge(
                value: cart.itemCount.toString(),
                child: ch!,
              );
            },
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions val) {
              if (val == FilterOptions.favorites) {
                favToggle.toggleFav(true);
              } else {
                favToggle.toggleFav(false);
              }
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show All'),
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder(
        future: _productFuture,
        builder: (_, snapshot) {
          return Consumer<Products>(
            builder: (_, product, __) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (product.items.isEmpty &&
                  snapshot.connectionState == ConnectionState.done) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Products in Shop...',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => Future.delayed(
                  const Duration(
                    seconds: 1,
                  ),
                ).then((_) => _productFuture),
                child: const ProductsGrid(),
              );
            },
          );
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
