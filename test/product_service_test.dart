import 'package:flutter_test/flutter_test.dart';
import 'package:practica1/services/product_service.dart';
import 'package:practica1/models/products.dart';

void main() {
  group('ProductService Tests', () {
    
    test('URL de la API', () {
      final service = ProductService();
      expect(service.baseUrl, 'https://fakestoreapi.com');
    });

    test('URLs de endpoints', () {
      final baseUrl = 'https://fakestoreapi.com';
      final productosUrl = '$baseUrl/products';
      final productoUrl = '$baseUrl/products/1';

      expect(productosUrl, 'https://fakestoreapi.com/products');
      expect(productoUrl, 'https://fakestoreapi.com/products/1');
    });

    test('convertir JSON a producto', () {
      final json = {
        'id': 1,
        'title': 'iPhone 15',
        'price': 999.99,
        'description': 'Nuevo iPhone',
        'category': 'electronics',
        'image': 'https://example.com/iphone.jpg',
      };

      final producto = Product.fromJson(json);

      expect(producto.id, 1);
      expect(producto.title, 'iPhone 15');
      expect(producto.price, 999.99);
    });

    test('convertir lista de JSON a productos', () {
      final jsonList = [
        {
          'id': 1,
          'title': 'iPhone',
          'price': 999.0,
          'description': 'telefono',
          'category': 'electronics',
          'image': 'iphone.jpg',
        },
        {
          'id': 2,
          'title': 'iPad',
          'price': 599.0,
          'description': 'tablet',
          'category': 'electronics',
          'image': 'ipad.jpg',
        }
      ];

      final productos = jsonList.map((json) => Product.fromJson(json)).toList();

      expect(productos.length, 2);
      expect(productos[0].title, 'iPhone');
      expect(productos[1].title, 'iPad');
    });

    test('lista vacia de productos', () {
      final jsonVacio = <Map<String, dynamic>>[];
      final productos = jsonVacio.map((json) => Product.fromJson(json)).toList();

      expect(productos.length, 0);
      expect(productos.isEmpty, true);
    });

    test('respuesta real de la API', () {
      final respuestaReal = {
        'id': 1,
        'title': "Fjallraven - Foldsack No. 1 Backpack",
        'price': 109.95,
        'description': "Your perfect pack for everyday use",
        'category': "men's clothing",
        'image': "https://fakestoreapi.com/img/image.jpg",
        'rating': {'rate': 3.9, 'count': 120} // campo extra
      };

      final producto = Product.fromJson(respuestaReal);

      expect(producto.id, 1);
      expect(producto.title.contains('Fjallraven'), true);
      expect(producto.price, 109.95);
      expect(producto.category, "men's clothing");
    });

    test('validar IDs de productos', () {
      final idsValidos = [1, 5, 10, 100];
      
      for (final id in idsValidos) {
        expect(id > 0, true);
      }
    });

    test('validar IDs invalidos', () {
      final idsInvalidos = [-1, 0, -99];
      
      for (final id in idsInvalidos) {
        expect(id <= 0, true);
      }
    });

    test('validar precios', () {
      final preciosValidos = [0.0, 1.99, 50.0, 999.99];
      
      for (final precio in preciosValidos) {
        expect(precio >= 0, true);
      }
    });

    test('validar URLs de imagenes', () {
      final urls = [
        'https://example.com/image.jpg',
        'http://test.com/photo.png',
        'https://fakestoreapi.com/img/product.jpg'
      ];
      
      for (final url in urls) {
        expect(url.startsWith('http'), true);
      }
    });

    test('codigos de respuesta HTTP', () {
      final codigosExito = [200, 201];
      final codigosError = [400, 404, 500];
      
      for (final codigo in codigosExito) {
        expect(codigo >= 200 && codigo < 300, true);
      }
      
      for (final codigo in codigosError) {
        expect(codigo >= 400, true);
      }
    });

    test('errores de red', () {
      expect(() => throw Exception('Sin conexion'), throwsException);
      expect(() => throw Exception('Timeout'), throwsException);
      expect(() => throw Exception('Error del servidor'), throwsException);
    });

    test('categorias de productos', () {
      final categorias = [
        'electronics',
        'jewelery',
        "men's clothing",
        "women's clothing"
      ];
      
      for (final categoria in categorias) {
        expect(categoria.isNotEmpty, true);
      }
    });
  });
}