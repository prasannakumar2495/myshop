import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/product.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  /*final String id;
  final String title;
  final String imageUrl;

  ProductItem(
    this.id,
    this.title,
    this.imageUrl,
  );*/

  @override
  Widget build(BuildContext context) {
    /* We have wrapped gridtile with clipRrect to add the borderradius.
    we can set listen: false, to not let the notifier to send the update. */
    /*final product = Provider.of<Product>(
      context,listen = false,
    );
    we are using Consumer, instead of provider.of method. 
    by using the Consumer, the widget will get all the updates.
    if the user want only sub widget to get the updates, the we use the provider.of , method and surround that sub-widget with Consumer instead of  the entire screen.*/
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    return Consumer<Product>(
      builder: (ctx, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(
          10,
        ),
        child: GridTile(
          /* No need to add a button, we can directly click on anything and move to relative page with this. */
          child: GestureDetector(
            onTap: () {
              /*Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ProductDetailsScreen(
                    title,
                  ),
                ),
              );*/
              Navigator.of(context).pushNamed(
                ProductDetailsScreen.routeName,
                arguments: product.id,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                /**we are adding this to display snackbar. */
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(
                      seconds: 2,
                    ),
                    content: Text(
                      'Added item to Cart.',
                    ),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.shopping_cart,
              ),
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
