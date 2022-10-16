import 'package:flutter/material.dart';
import 'package:myshop/providers/products_provider.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  const UserProductItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(
      context,
      listen: false,
    );
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: (() {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id,
                );
              }),
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: (() {
                productData.deleteProduct(id);
              }),
              color: Theme.of(context).errorColor,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
