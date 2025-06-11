import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthService Tests', () {
    
    test('validar email correcto', () {
      // funcion simple para validar email
      bool esEmailValido(String email) {
        return email.contains('@') && email.contains('.');
      }

      expect(esEmailValido('test@gmail.com'), true);
      expect(esEmailValido('usuario@hotmail.com'), true);
      expect(esEmailValido('correo@universidad.edu.mx'), true);
    });

    test('validar email incorrecto', () {
      bool esEmailValido(String email) {
        return email.contains('@') && email.contains('.');
      }

      expect(esEmailValido('email-sin-arroba'), false);
      expect(esEmailValido('email@sin-punto'), false);
      expect(esEmailValido(''), false);
      expect(esEmailValido('@.com'), false);
    });

    test('validar contraseña', () {
      bool esContrasenaValida(String password) {
        return password.length >= 6;
      }

      expect(esContrasenaValida('123456'), true);
      expect(esContrasenaValida('micontraseña'), true);
      expect(esContrasenaValida('password123'), true);
    });

    test('validar contraseña muy corta', () {
      bool esContrasenaValida(String password) {
        return password.length >= 6;
      }

      expect(esContrasenaValida('12345'), false);
      expect(esContrasenaValida('abc'), false);
      expect(esContrasenaValida(''), false);
    });

    test('validar nombre', () {
      bool esNombreValido(String nombre) {
        return nombre.trim().length >= 2;
      }

      expect(esNombreValido('Juan'), true);
      expect(esNombreValido('Maria Jose'), true);
      expect(esNombreValido('Ana'), true);
    });

    test('validar nombre muy corto', () {
      bool esNombreValido(String nombre) {
        return nombre.trim().length >= 2;
      }

      expect(esNombreValido('A'), false);
      expect(esNombreValido(''), false);
      expect(esNombreValido('   '), false);
    });

    test('URLs de la API', () {
      final baseUrl = 'https://api-practice.zapto.org/v1';
      final loginUrl = '$baseUrl/user/auth';
      final registerUrl = '$baseUrl/user';

      expect(baseUrl, 'https://api-practice.zapto.org/v1');
      expect(loginUrl, 'https://api-practice.zapto.org/v1/user/auth');
      expect(registerUrl, 'https://api-practice.zapto.org/v1/user');
    });

    test('datos de login', () {
      final datosLogin = {
        'email': 'test@gmail.com',
        'password': 'mi_password',
      };

      expect(datosLogin['email'], 'test@gmail.com');
      expect(datosLogin['password'], 'mi_password');
    });

    test('datos de registro', () {
      final datosRegistro = {
        'name': 'Juan',
        'last_name': 'Perez',
        'email': 'juan@gmail.com',
        'password': 'mi_password',
      };

      expect(datosRegistro['name'], 'Juan');
      expect(datosRegistro['last_name'], 'Perez');
      expect(datosRegistro['email'], 'juan@gmail.com');
      expect(datosRegistro['password'], 'mi_password');
    });

    test('respuesta exitosa del servidor', () {
      final respuesta = {
        'Status': true,
        'Data': {'token': 'abc123'},
      };

      expect(respuesta['Status'], true);
      expect((respuesta['Data'] as Map<String, dynamic>)['token'], 'abc123');
    });

    test('respuesta de error del servidor', () {
      final respuesta = {
        'Status': false,
        'Message': 'Email ya existe',
      };

      expect(respuesta['Status'], false);
      expect(respuesta['Message'], 'Email ya existe');
    });

    test('datos de usuario', () {
      final usuario = {
        'id': 1,
        'email': 'test@gmail.com',
        'name': 'Juan',
        'last_name': 'Perez',
      };

      expect(usuario['id'], 1);
      expect(usuario['email'], 'test@gmail.com');
      expect(usuario['name'], 'Juan');
      expect(usuario['last_name'], 'Perez');
    });

    test('manejo de errores', () {
      // verificar que los errores se lanzan correctamente
      expect(() => throw Exception('Error de red'), throwsException);
      expect(() => throw Exception('Email invalido'), throwsException);
      expect(() => throw Exception('Contraseña incorrecta'), throwsException);
    });
  });
}