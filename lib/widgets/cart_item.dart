import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final String productId;
  final String title;
  final int quantity;

  const CartItem({
    Key? key,
    required this.id,
    required this.price,
    required this.productId,
    required this.quantity,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text(
                  'Confirming, will remove all the count of a particular product.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('NO'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('YES'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                child: Text(
                  '\$$price',
                ),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
          trailing: Text('${quantity}x'),
        ),
      ),
    );
  }
}
