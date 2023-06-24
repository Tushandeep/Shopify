import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_var.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatefulWidget {
  const ProductsGrid({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  @override
  Widget build(BuildContext context) {
    final showFav = Provider.of<ShowFavorite>(
      context,
    );
    final productsData = Provider.of<Products>(context);
    final products = showFav.getShowFavValue()
        ? productsData.favoriteItems
        : productsData.items;
    return Builder(
      builder: (_) {
        if (showFav.getShowFavValue() && products.isEmpty) {
          return Center(
            child: GestureDetector(
              onTap: () {
                showFav.toggleFav(false);
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.favorite_outline_rounded,
                    size: 100,
                  ),
                  Text(
                    'No favorites yet!!',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (_, index) {
            return ChangeNotifierProvider.value(
              value: products[index],
              child: const ProductItem(),
            );
          },
          itemCount: products.length,
        );
      },
    );
  }
}
