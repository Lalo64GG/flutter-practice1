import 'package:flutter/material.dart';
import '../models/products.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(product.image),
            SizedBox(height: 16),
            Text(product.description),
            SizedBox(height: 16),
            Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
