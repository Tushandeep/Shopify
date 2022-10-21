import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

class TotalAmountCard extends StatelessWidget {
  const TotalAmountCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Card(
      margin: const EdgeInsets.all(15.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const Spacer(),
            Chip(
              label: Text(
                '\$' + cart.totalAmount.toStringAsFixed(2),
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.headline6!.color,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(
              width: 10,
            ),
            OrderButton(cart: cart),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.cart.totalAmount <= 0 || _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false)
                  .addOrder(widget.cart.itemsValues, widget.cart.totalAmount)
                  .then(
                (_) {
                  setState(
                    () {
                      _isLoading = false;
                    },
                  );
                },
              );
              widget.cart.clear();
            },
      child: const Text(
        'Order Now',
      ),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          (widget.cart.totalAmount <= 0)
              ? Theme.of(context).primaryColor.withOpacity(0.4)
              : Theme.of(context).primaryColor,
        ),
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).primaryTextTheme.headline6!.color,
        ),
      ),
    );
  }
}
