import 'package:flutter/material.dart';
import 'package:myshop/screens/order_screen.dart';
import 'package:myshop/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /**
     * we are using the Drawer widget to display the 3 horizontal line button.
     */
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            /**
             * the below will not allow adding back button in the appbar.
             */
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(
              'Shop',
            ),
            onTap: () {
              /**this will navigate to the root route */
              Navigator.of(context).pushReplacementNamed(
                '/',
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              'Orders',
            ),
            onTap: () {
              /**this will navigate to the root route */
              Navigator.of(context).pushReplacementNamed(
                OrdersScreen.routeName,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(
              'Manage Products',
            ),
            onTap: () {
              /**this will navigate to the root route */
              Navigator.of(context).pushReplacementNamed(
                UserProductsScreen.routeName,
              );
            },
          ),
        ],
      ),
    );
  }
}
