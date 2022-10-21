import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart';
import 'order_items_list.dart';

class OrderItemTile extends StatefulWidget {
  final OrderItem order;
  const OrderItemTile({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItemTile> createState() => _OrderItemTileState();
}

class _OrderItemTileState extends State<OrderItemTile> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(
        10.0,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              '\$${widget.order.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Dated:  ${DateFormat('dd/MM/yyyy').format(
                widget.order.dateTime,
              )}\t\t\t\t\t\t\tTime:  ${DateFormat('hh:mm a').format(widget.order.dateTime)}',
            ),
            trailing: IconButton(
              icon: Icon((!_expanded) ? Icons.expand_more : Icons.expand_less),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              splashRadius: 20,
            ),
          ),
          OrderItemList(
            widget: widget,
            expand: _expanded,
          ),
        ],
      ),
    );
  }
}
