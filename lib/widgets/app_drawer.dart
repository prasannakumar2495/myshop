import 'package:flutter/material.dart';
import 'package:myshop/animations/custom_route.dart';
import 'package:myshop/providers/auth.dart';
import 'package:myshop/screens/orders_screen.dart';
import 'package:myshop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading:
                false, //this will make sure a back button is not added.
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: (() {
              Navigator.of(context).pushReplacementNamed('/');
            }),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Payment'),
            onTap: (() {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            }),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: (() {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
              // Navigator.of(context).pushReplacement(
              //   CustomRoute(
              //     builder: (context) => const UserProductsScreen(),
              //     settings: null,
              //   ),
              // );
            }),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: (() {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logOut();
            }),
          ),
        ],
      ),
    );
  }
}
