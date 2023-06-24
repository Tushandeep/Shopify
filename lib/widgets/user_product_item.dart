import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../screens/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      {Key? key, required this.id, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(
      context,
      listen: false,
    );
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(
        title,
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              splashRadius: 20,
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: [id, true]);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              splashRadius: 20,
              icon: const Icon(Icons.delete),
              onPressed: () async {
                try {
                  await productsData.deleteProduct(id);
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Deleted Successfully!!',
                      ),
                    ),
                  );
                } catch (error) {
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Deleting Failed!!',
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
