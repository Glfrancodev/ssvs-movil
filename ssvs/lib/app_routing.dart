import 'package:flutter/material.dart';
import 'package:ssvs/screens/reserva_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/mis_reservas_screen.dart';
import 'screens/historia_clinica_screen.dart';


class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String realizarReserva = '/realizarReserva';
  static const String misReservas = '/misReservas';
  static const String historiaClinica = '/historiaClinica';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case realizarReserva:
        return MaterialPageRoute(builder: (_) => ReservaScreen());
      case misReservas:
        return MaterialPageRoute(builder: (_) => MisReservasScreen());
      case historiaClinica:
        return MaterialPageRoute(builder: (_) => HistoriaClinicaScreen());
      case AppRoutes.historiaClinica:
        return MaterialPageRoute(builder: (_) => HistoriaClinicaScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}
