import 'package:flutter/material.dart';
import '../services/consulta_service.dart';
import '../models/consulta.dart';
import '../widgets/base_screen.dart';
import '../screens/detalle_consulta_screen.dart';

class HistoriaClinicaScreen extends StatefulWidget {
  @override
  _HistoriaClinicaScreenState createState() => _HistoriaClinicaScreenState();
}

class _HistoriaClinicaScreenState extends State<HistoriaClinicaScreen> {
  final ConsultaService consultaService = ConsultaService();
  List<Consulta> consultas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchConsultas();
  }

  Future<void> _fetchConsultas() async {
    try {
      final historiaClinicaId = 1; // Reemplaza con el ID de la historia clínica del asegurado autenticado
      final consultasList = await consultaService.obtenerConsultasPorHistoriaClinica(historiaClinicaId);
      setState(() {
        consultas = consultasList;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar las consultas: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Historia Clínica',
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : consultas.isEmpty
              ? Center(
                  child: Text(
                    'No tienes consultas en tu historia clínica',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: consultas.length,
                  itemBuilder: (context, index) {
                    final consulta = consultas[index];
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Fecha: ${consulta.fechaConsulta}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.more_horiz, color: Colors.blueAccent),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetalleConsultaScreen(
                                          consulta: consulta,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Motivo: ${consulta.motivoConsulta}',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                            if (consulta.diagnostico != null && consulta.diagnostico!.isNotEmpty)
                              Text(
                                'Diagnóstico: ${consulta.diagnostico}',
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            if (consulta.nota != null && consulta.nota!.isNotEmpty)
                              Text(
                                'Nota: ${consulta.nota}',
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            SizedBox(height: 8),
                            Text(
                              'Médico: ${consulta.cupo?.horario?.medicoEspecialidad?.medico?.usuario?.nombre ?? ''} ${consulta.cupo?.horario?.medicoEspecialidad?.medico?.usuario?.apellido ?? ''}',
                              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
