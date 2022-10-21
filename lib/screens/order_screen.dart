import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/products_overview_screen.dart';
import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders-screen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _orderFuture;

  Future<void> _fetchData() async {
    // Future.delayed(Duration.zero).then((_) {});
    // _isLoading = true;
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    // .then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
  }

  @override
  void initState() {
    super.initState();
    _orderFuture = _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Consumer<Orders>(
            builder: (_, ordersData, __) {
              if (ordersData.orders.isEmpty &&
                  snapshot.connectionState == ConnectionState.done) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(ProductsOverviewScreen.routeName);
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.task_outlined,
                          size: 100,
                        ),
                        Text(
                          'No orders placed yet!!',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (_, index) {
                  return OrderItemTile(order: ordersData.orders[index]);
                },
              );
            },
          );
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
