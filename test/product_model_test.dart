import 'package:flutter_test/flutter_test.dart';
import 'package:practica1/models/products.dart';

void main() {
  group('Product Tests', () {
    
    test('crear producto basico', () {
      final producto = Product(
        id: 1,
        title: 'iPhone 15',
        price: 999.99,
        description: 'El nuevo iPhone',
        category: 'electronics',
        image: 'iphone.jpg',
      );

      expect(producto.id, 1);
      expect(producto.title, 'iPhone 15');
      expect(producto.price, 999.99);
    });

    test('crear producto desde JSON', () {
      final json = {
        'id': 2,
        'title': 'Laptop',
        'price': 1500.0,
        'description': 'Laptop gaming',
        'category': 'electronics',
        'image': 'laptop.jpg',
      };

      final producto = Product.fromJson(json);

      expect(producto.id, 2);
      expect(producto.title, 'Laptop');
      expect(producto.price, 1500.0);
    });

    test('producto con precio entero', () {
      final json = {
        'id': 3,
        'title': 'Mouse',
        'price': 25, // precio entero
        'description': 'Mouse inalambrico',
        'category': 'electronics',
        'image': 'mouse.jpg',
      };

      final producto = Product.fromJson(json);
      expect(producto.price, 25.0);
    });

    test('producto gratis', () {
      final producto = Product(
        id: 4,
        title: 'App gratis',
        price: 0.0,
        description: 'Aplicacion gratuita',
        category: 'software',
        image: 'app.jpg',
      );

      expect(producto.price, 0.0);
    });

    test('JSON con campos extra', () {
      final json = {
        'id': 5,
        'title': 'Libro',
        'price': 15.99,
        'description': 'Libro de programacion',
        'category': 'books',
        'image': 'libro.jpg',
        'autor': 'Juan Perez', // campo extra
        'paginas': 300, // campo extra
      };

      final producto = Product.fromJson(json);
      expect(producto.title, 'Libro');
      expect(producto.price, 15.99);
    });

    test('error con JSON incompleto', () {
      final json = {
        'id': 6,
        'title': 'Producto incompleto',
        // faltan campos
      };

      expect(() => Product.fromJson(json), throwsA(anything));
    });

    test('error con campo null', () {
      final json = {
        'id': 7,
        'title': null,
        'price': 10.0,
        'description': 'test',
        'category': 'test',
        'image': 'test.jpg',
      };

      expect(() => Product.fromJson(json), throwsA(anything));
    });

    test('varios productos diferentes', () {
      final productos = [
        Product(id: 1, title: 'A', price: 1.0, description: 'a', category: 'a', image: 'a.jpg'),
        Product(id: 2, title: 'B', price: 2.0, description: 'b', category: 'b', image: 'b.jpg'),
        Product(id: 3, title: 'C', price: 3.0, description: 'c', category: 'c', image: 'c.jpg'),
      ];

      expect(productos.length, 3);
      expect(productos[0].title, 'A');
      expect(productos[1].price, 2.0);
      expect(productos[2].id, 3);
    });

    test('producto con titulo largo', () {
      final producto = Product(
        id: 8,
        title: 'Este es un titulo muy largo para un producto que tiene muchas palabras',
        price: 50.0,
        description: 'Descripcion normal',
        category: 'test',
        image: 'test.jpg',
      );

      expect(producto.title.length, greaterThan(20));
    });

    test('precios diferentes', () {
      final precios = [0.01, 5.99, 100.0, 999.99];
      
      for (int i = 0; i < precios.length; i++) {
        final producto = Product(
          id: i,
          title: 'Producto $i',
          price: precios[i],
          description: 'test',
          category: 'test',
          image: 'test.jpg',
        );
        expect(producto.price, precios[i]);
      }
    });
  });
}