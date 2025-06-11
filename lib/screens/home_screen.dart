import 'package:flutter/material.dart';
import 'package:practica1/main.dart';
import '../services/auth_service.dart';
import '../screens/cart_screen.dart';
import '../cart/cart.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final CustomUser? user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Cart cart = Cart();

  @override
  void initState() {
    super.initState();
    cart.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola ${widget.user?.displayName ?? 'Usuario'}'),
        actions: [
          // Botón del carrito con badge
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cart.itemCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          // Botón de logout
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: ProductListScreen(), // Aquí está el cambio principal
    );
  }

  @override
  void dispose() {
    cart.removeListener(() {});
    super.dispose();
  }
}