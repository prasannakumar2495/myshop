import 'package:flutter/material.dart';
import 'package:myshop/providers/orders.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/ordersScreen';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return const Center(
                child: Text('Error Occured!'),
              );
            } else {
              return Consumer<Orders>(
                builder: ((context, value, child) => ListView.builder(
                      itemBuilder: ((context, index) =>
                          OrderItemWidget(order: value.orders[index])),
                      itemCount: value.orders.length,
                    )),
              );
            }
          }
        }),
      ),
    );
  }
}
