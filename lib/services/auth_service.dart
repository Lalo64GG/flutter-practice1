import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Clase personalizada para manejar usuarios de ambas fuentes
class CustomUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool isEmailVerified;
  final bool isFromGoogle;

  CustomUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.isEmailVerified = false,
    this.isFromGoogle = false,
  });

  // Constructor para crear desde Firebase User
  factory CustomUser.fromFirebaseUser(User user) {
    return CustomUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      isEmailVerified: user.emailVerified,
      isFromGoogle: true,
    );
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // URL base de tu API - actualiza con tu dominio real
  static const String _baseUrl = 'https://api-practice.zapto.org/v1';
  
  // Método existente de Google Sign In
  Future<CustomUser?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential( 
      accessToken: googleAuth.accessToken, 
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    
    if (userCredential.user != null) {
      return CustomUser.fromFirebaseUser(userCredential.user!);
    }
    
    return null;
  }

  // Método corregido para inicio de sesión con email y contraseña
  Future<CustomUser?> signInWithEmailPassword(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/user/auth'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Verificar si la respuesta es exitosa
        if (data['Status'] == true) {
          // Guardar token en SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['Data']['token']);
          
          // Obtener datos del usuario usando el token
          final userData = await getUserById();
          if (userData != null) {
            await prefs.setString('user_data', jsonEncode(userData));
            
            // Crear objeto CustomUser
            return CustomUser(
              uid: userData['id'].toString(),
              email: userData['email'],
              displayName: '${userData['name']} ${userData['last_name']}',
              photoURL: userData['photo_url'], // Si tu API lo maneja
              isEmailVerified: true,
            );
          }
          
          return null;
        } else {
          throw Exception(data['Message'] ?? 'Error en el inicio de sesión');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['Message'] ?? 'Error en el inicio de sesión');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método corregido para registro con email y contraseña
  Future<CustomUser?> registerWithEmailPassword(String email, String password, String name, String lastName) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'last_name': lastName,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Verificar si la respuesta es exitosa
        if (data['Status'] == true) {
          // Después del registro exitoso, hacer login automáticamente
          return await signInWithEmailPassword(email, password);
        } else {
          throw Exception(data['Message'] ?? 'Error en el registro');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['Message'] ?? 'Error en el registro');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener datos del usuario por ID
  Future<Map<String, dynamic>?> getUserById() async {
    try {
      final token = await getAuthToken();
      if (token == null) return null;

      // Decodificar el token para obtener el ID del usuario
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = jsonDecode(decoded);
      final userId = payloadMap['id'];

      final response = await http.get(
        Uri.parse('$_baseUrl/user/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Status'] == true) {
          return data['Data'];
        }
      }
      return null;
    } catch (e) {
      print('Error obteniendo datos del usuario: $e');
      return null;
    }
  }

  // Método para obtener el token guardado
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Método para obtener datos del usuario guardados
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  // Método para verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    if (token == null) return false;
    
    // Verificar si el token no ha expirado
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = jsonDecode(decoded);
      
      final exp = payloadMap['exp'];
      if (exp != null) {
        final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        if (DateTime.now().isAfter(expirationDate)) {
          // Token expirado
          await signOut();
          return false;
        }
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    // Cerrar sesión de Google
    await _googleSignIn.signOut();
    await _auth.signOut();
    
    // Limpiar datos de la API propia
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  // Método para hacer peticiones autenticadas a tu API
  Future<http.Response> authenticatedRequest(String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(Uri.parse('$_baseUrl$endpoint'), headers: headers);
      case 'POST':
        return await http.post(
          Uri.parse('$_baseUrl$endpoint'),
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PUT':
        return await http.put(
          Uri.parse('$_baseUrl$endpoint'),
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'DELETE':
        return await http.delete(Uri.parse('$_baseUrl$endpoint'), headers: headers);
      default:
        throw Exception('Método HTTP no soportado');
    }
  }

  // Método helper para refrescar datos del usuario
  Future<void> refreshUserData() async {
    final userData = await getUserById();
    if (userData != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(userData));
    }
  }
}