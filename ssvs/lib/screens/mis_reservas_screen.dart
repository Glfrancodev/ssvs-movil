import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';
import '../services/cupo_service.dart';
import '../models/cupo.dart';

class MisReservasScreen extends StatefulWidget {
  @override
  _MisReservasScreenState createState() => _MisReservasScreenState();
}

class _MisReservasScreenState extends State<MisReservasScreen> {
  final CupoService cupoService = CupoService();
  List<Cupo> cupos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCupos();
  }

  Future<void> _fetchCupos() async {
    try {
      // Reemplaza con el ID del asegurado autenticado
      final aseguradoId = 1; // Obtén este ID desde el sistema de autenticación
      final cuposList = await cupoService.obtenerCuposPorAsegurado(aseguradoId);

      // Filtrar solo cupos con estado "Ocupado"
      setState(() {
        cupos = cuposList.where((cupo) => cupo.estado == "Ocupado").toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los cupos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _quitarCupo(Cupo cupo) async {
    try {
      await cupoService.quitarCupo(cupo.id!);

      // Actualizar lista de reservas localmente
      setState(() {
        cupos.remove(cupo);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reserva eliminada correctamente')),
      );
    } catch (e) {
      print('Error al eliminar el cupo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la reserva')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Mis Reservas',
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cupos.isEmpty
              ? Center(
                  child: Text(
                    'No tienes reservas actualmente',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: cupos.length,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  itemBuilder: (context, index) {
                    final cupo = cupos[index];
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            '${cupo.numero}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          'Estado: ${cupo.estado}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Fecha: ${cupo.horario!.fecha}\nHora: ${cupo.hora}',
                          style: TextStyle(color: Colors.black54),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Eliminar Reserva'),
                                content: Text(
                                    '¿Estás seguro de que deseas eliminar esta reserva?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _quitarCupo(cupo);
                                    },
                                    child: Text(
                                      'Eliminar',
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
