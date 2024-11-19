import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../app_routing.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final AuthService _authService = AuthService();

  String nombreCompleto = 'Usuario';
  String correo = 'usuario@correo.com';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final correoUsuario = await _authService.getCorreo();
    if (correoUsuario != null) {
      final asegurado = await _authService.obtenerAseguradoPorCorreo(correoUsuario);
      setState(() {
        correo = correoUsuario;
        nombreCompleto = '${asegurado['nombre']} ${asegurado['apellido']}';
      });
    }
  }

  void _logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
                  ),
                  SizedBox(height: 10),
                  Text(
                    nombreCompleto,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    correo,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_circle_outline, color: Colors.white),
              title: Text(
                'Realizar Reserva',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.realizarReserva);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.white),
              title: Text(
                'Mis Reservas',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.misReservas);
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.white),
              title: Text(
                'Historia Clínica',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.historiaClinica);
              },
            ),
            Divider(color: Colors.white54),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
