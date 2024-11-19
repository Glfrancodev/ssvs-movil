import 'package:flutter/material.dart';
import 'app_routing.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive) {
      // Borra el token cuando la aplicación se cierra
      _authService.clearToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seguro Salud Vida Sana',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false, // Ocultar el banner de "Debug"
      home: FutureBuilder(
        future: _authService.isAuthenticated(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.data == true) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
