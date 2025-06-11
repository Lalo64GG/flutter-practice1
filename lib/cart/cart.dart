import 'package:flutter/foundation.dart';
import '../models/products.dart';

class Cart extends ChangeNotifier {
  static final Cart _instance = Cart._internal();
  factory Cart() => _instance;
  Cart._internal();

  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  double get total => _items.fold(0, (sum, item) => sum + item.price);

  void add(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Obtener cantidad de un producto específico
  int getQuantity(Product product) {
    return _items.where((item) => item.id == product.id).length;
  }

  // Verificar si un producto está en el carrito
  bool contains(Product product) {
    return _items.any((item) => item.id == product.id);
  }
}
