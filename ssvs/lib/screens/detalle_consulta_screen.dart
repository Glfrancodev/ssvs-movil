import 'package:flutter/material.dart';
import '../models/consulta.dart';
import '../models/receta.dart';
import '../models/archivo.dart';
import '../services/receta_service.dart';
import '../services/tratamiento_service.dart';
import '../services/archivo_service.dart';

class DetalleConsultaScreen extends StatefulWidget {
  Consulta consulta;

  DetalleConsultaScreen({required this.consulta});

  @override
  _DetalleConsultaScreenState createState() => _DetalleConsultaScreenState();
}

class _DetalleConsultaScreenState extends State<DetalleConsultaScreen> {
  final RecetaService recetaService = RecetaService();
  final TratamientoService tratamientoService = TratamientoService();
  final ArchivoService archivoService = ArchivoService();

  List<Receta> recetas = [];
  List<Archivo> archivos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      print('Iniciando carga de detalles para consulta ID: ${widget.consulta.id}');

      if (widget.consulta.tratamiento?.id == null) {
        final tratamiento = await tratamientoService.obtenerTratamientoPorConsultaId(widget.consulta.id!);
        if (tratamiento != null) {
          setState(() {
            widget.consulta = Consulta(
              id: widget.consulta.id,
              fechaConsulta: widget.consulta.fechaConsulta,
              motivoConsulta: widget.consulta.motivoConsulta,
              diagnostico: widget.consulta.diagnostico,
              nota: widget.consulta.nota,
              cupo: widget.consulta.cupo,
              historiaClinica: widget.consulta.historiaClinica,
              tratamiento: tratamiento,
            );
          });
        }
      }

      if (widget.consulta.tratamiento?.id != null) {
        final recetasList = await recetaService.obtenerRecetasPorTratamientoId(widget.consulta.tratamiento!.id!);
        setState(() {
          recetas = recetasList;
        });
      }

      final archivosList = await archivoService.listarArchivosPorConsulta(widget.consulta.id!);
      setState(() {
        archivos = archivosList;
      });
    } catch (e) {
      print('Error al cargar detalles: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle de Consulta')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Detalles principales
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Consulta ID: ${widget.consulta.id ?? 'N/A'}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 10),
                          Text('Fecha: ${widget.consulta.fechaConsulta}', style: TextStyle(fontSize: 16)),
                          Text('Motivo: ${widget.consulta.motivoConsulta}', style: TextStyle(fontSize: 16)),
                          Text('Nota: ${widget.consulta.nota ?? 'Sin notas'}', style: TextStyle(fontSize: 16)),
                          Text(
                            'Médico: ${widget.consulta.cupo?.horario?.medicoEspecialidad?.medico?.usuario?.nombre ?? ''} ${widget.consulta.cupo?.horario?.medicoEspecialidad?.medico?.usuario?.apellido ?? ''}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Recetas
                  Text('Recetas:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  recetas.isEmpty
                      ? Text('No hay recetas asociadas a esta consulta.', style: TextStyle(color: Colors.grey))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: recetas.length,
                          itemBuilder: (context, index) {
                            final receta = recetas[index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Medicamento: ${receta.medicamento}',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text('Frecuencia: ${receta.frecuencia}'),
                                    Text('Inicio: ${receta.fechaInicio}'),
                                    Text('Fin: ${receta.fechaFinal}'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  SizedBox(height: 16),

                  // Archivos
                  Text('Archivos Adjuntos:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  archivos.isEmpty
                      ? Text('No hay archivos adjuntos para esta consulta.', style: TextStyle(color: Colors.grey))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: archivos.length,
                          itemBuilder: (context, index) {
                            final archivo = archivos[index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                leading: Icon(Icons.insert_drive_file, color: Colors.blue),
                                title: Text(archivo.nombre),
                                trailing: IconButton(
                                  icon: Icon(Icons.download, color: Colors.green),
                                  onPressed: () async {
                                    try {
                                      await archivoService.descargarArchivo(archivo.nombre);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Archivo descargado: ${archivo.nombre}')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error al descargar el archivo: $e')),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
