import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/custom_route.dart';

import './providers/auth.dart';
import './providers/favorite_var.dart';
import './screens/auth_screen.dart';
import './screens/edit_product.dart';
import './screens/user_products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(null, null, []),
          update: (_, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts!.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(null, null, []),
          update: (_, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders!.orders,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ShowFavorite(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (_, auth, __) {
          return MaterialApp(
            routes: {
              ProductDetailScreen.routeName: (_) => const ProductDetailScreen(),
              ProductsOverviewScreen.routeName: (_) =>
                  const ProductsOverviewScreen(),
              CartScreen.routeName: (_) => const CartScreen(),
              OrdersScreen.routeName: (_) => const OrdersScreen(),
              UserProductsScreen.routeName: (_) => const UserProductsScreen(),
              EditProductScreen.routeName: (_) => const EditProductScreen(),
              AuthScreen.routeName: (_) => const AuthScreen(),
            },
            title: 'Shop App',
            home: (auth.isAuth)
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (_, authResultSnapshot) {
                      if (authResultSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(
                            child: Text(
                              'Loading...',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                        );
                      }
                      return const AuthScreen();
                    },
                  ),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                },
              ),
              appBarTheme: const AppBarTheme(
                color: Colors.purple,
                actionsIconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
              primarySwatch: Colors.purple,
              colorScheme: Theme.of(context)
                  .colorScheme
                  .copyWith(secondary: Colors.orange),
              fontFamily: 'Lato',
            ),
          );
        },
      ),
    );
  }
}
