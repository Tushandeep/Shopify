import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product-detail';
  const ProductDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    final loadProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return SafeArea(
      top: true,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 350,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              pinned: true,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  loadProduct.title,
                ),
                background: Hero(
                  tag: loadProduct.id,
                  child: Image.network(
                    loadProduct.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '\$${loadProduct.price}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      loadProduct.description,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(
                    height: 800,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
