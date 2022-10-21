import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../widgets/total_amount_card.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart-screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          const TotalAmountCard(),
          const SizedBox(
            height: 10,
          ),
          Builder(
            builder: (_) {
              if (cart.totalAmount <= 0) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 100,
                          ),
                          Text(
                            'Add items to cart',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) {
                    return CartItem(
                      id: cart.itemsValues[index].id,
                      title: cart.itemsValues[index].title,
                      productId: cart.itemsKeys[index],
                      price: cart.itemsValues[index].price,
                      quantity: cart.itemsValues[index].quantity,
                    );
                  },
                  itemCount: cart.itemCount,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


/*


*/