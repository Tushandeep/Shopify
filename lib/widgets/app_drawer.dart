import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/custom_route.dart';

import '../providers/auth.dart';
import '../screens/order_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/user_products.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Welcome to Shop'),
            automaticallyImplyLeading: false,
          ),
          const Divider(
            indent: 10,
            endIndent: 30,
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductsOverviewScreen.routeName);
            },
          ),
          const Divider(
            indent: 10,
            endIndent: 30,
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
              // Navigator.of(context).pushReplacement(
              //   CustomRoute(
              //     builder: (_) => const OrdersScreen(),
              //   ),
              // );
            },
          ),
          const Divider(
            indent: 10,
            endIndent: 30,
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(
            indent: 10,
            endIndent: 30,
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          const Divider(
            indent: 10,
            endIndent: 30,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
