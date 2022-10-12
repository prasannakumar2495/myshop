import 'package:flutter/material.dart';
import 'package:myshop/providers/orders.dart';
import 'package:myshop/screens/orders_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Column(children: <Widget>[
        Card(
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                TextButton(
                  onPressed: (() {
                    var orders = Provider.of<Orders>(
                      context,
                      listen: false,
                    );
                    orders.addOrder(
                      cart.items.values.toList(),
                      cart.totalAmount,
                    );
                    cart.clear();

                    Navigator.of(context).pushNamed(OrdersScreen.routeName);
                  }),
                  child: const Text('ORDER NOW'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemBuilder: ((context, index) => CartScreenItem(
                  //BCZ, items is a MAP.
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                  title: cart.items.values.toList()[index].title,
                  quantity: cart.items.values.toList()[index].quantity,
                  price: cart.items.values.toList()[index].price,
                )),
            itemCount: cart.itemCount,
          ),
        ),
      ]),
    );
  }
}
