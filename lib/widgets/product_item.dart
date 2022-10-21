import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    final authData = Provider.of<Auth>(context, listen: false);
    return Consumer<Product>(
      builder: (_, product, __) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GridTile(
            footer: Tooltip(
              message: product.title,
              child: GridTileBar(
                title: Text(
                  product.title,
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.black54,
                leading: IconButton(
                  icon: Icon(
                    (product.isFavorite)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  onPressed: () {
                    product.toggleFavoriteStatus(
                        authData.token, authData.userId);
                  },
                  color: Theme.of(context).colorScheme.secondary,
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {
                    cart.addItem(product.id, product.price, product.title);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          (cart.getCartItemIndex(product.id).quantity == 1)
                              ? '"${product.title}" added to your cart'
                              : '${cart.getCartItemIndex(product.id).quantity}x "${product.title}" added to your cart',
                        ),
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  (cart.getCartItemIndex(product.id).quantity ==
                                          1)
                                      ? '"${product.title}" removed from your cart'
                                      : '1 "${product.title}" removed from your cart.\n\nRemaining ${cart.getCartItemIndex(product.id).quantity - 1} ${product.title}.',
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            cart.removeSingleItem(product.id);
                          },
                        ),
                      ),
                    );
                  },
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id,
                );
              },
              onDoubleTap: () {
                if (!product.isFavorite) {
                  product.toggleFavoriteStatus(authData.token, authData.userId);
                }
              },
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:
                      const AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
