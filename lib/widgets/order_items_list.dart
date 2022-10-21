import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/order_item.dart';

class OrderItemList extends StatelessWidget {
  final bool expand;
  const OrderItemList({
    Key? key,
    required this.widget,
    required this.expand,
  }) : super(key: key);

  final OrderItemTile widget;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 600,
      ),
      padding: const EdgeInsets.all(
        15.0,
      ),
      height: expand ? min(widget.order.products.length * 20.0 + 40, 180) : 0,
      child: ListView(
        children: widget.order.products
            .map(
              (prod) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    (prod.title.length <= 25)
                        ? prod.title
                        : '${prod.title.substring(0, 25)}...',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${prod.price}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          '${prod.quantity}x',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
