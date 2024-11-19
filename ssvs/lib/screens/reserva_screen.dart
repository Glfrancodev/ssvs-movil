import 'package:flutter/material.dart';
import '../widgets/sidebar.dart'; // Asegúrate de tener el widget Sidebar implementado
import '../services/medico_especialidad_service.dart';
import '../services/especialidad_service.dart';
import '../services/medico_service.dart';
import '../services/horario_service.dart';
import '../services/cupo_service.dart';
import '../models/especialidad.dart';
import '../models/medico.dart';
import '../models/horario.dart';
import '../models/cupo.dart';

class ReservaScreen extends StatefulWidget {
  @override
  _ReservaScreenState createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  final EspecialidadService especialidadService = EspecialidadService();
  final MedicoService medicoService = MedicoService();
  final HorarioService horarioService = HorarioService();
  final CupoService cupoService = CupoService();
  final MedicoEspecialidadService medicoEspecialidadService = MedicoEspecialidadService();

  List<Especialidad> especialidades = [];
  List<Medico> medicos = [];
  List<Horario> horarios = [];
  List<Cupo> cupos = [];

  Especialidad? selectedEspecialidad;
  Medico? selectedMedico;
  Horario? selectedHorario;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchEspecialidades();
  }

  Future<void> _fetchEspecialidades() async {
    setState(() => isLoading = true);
    try {
      final data = await especialidadService.obtenerEspecialidades();
      setState(() => especialidades = data);
    } catch (e) {
      print('Error al cargar especialidades: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchMedicos() async {
    if (selectedEspecialidad?.id != null) {
      setState(() => isLoading = true);
      try {
        final data = await medicoEspecialidadService.obtenerMedicosPorEspecialidad(selectedEspecialidad!.id!);
        setState(() => medicos = data);
      } catch (e) {
        print('Error al cargar médicos: $e');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _fetchHorarios() async {
    if (selectedEspecialidad?.id != null && selectedMedico?.id != null) {
      setState(() => isLoading = true);
      try {
        final medicoEspecialidadId = await medicoEspecialidadService.obtenerMedicoEspecialidadId(
          selectedEspecialidad!.id!,
          selectedMedico!.id!,
        );
        if (medicoEspecialidadId != null) {
          final horariosList = await horarioService.obtenerHorariosPorMedicoEspecialidad(medicoEspecialidadId);
          setState(() => horarios = horariosList);
        }
      } catch (e) {
        print('Error al cargar horarios: $e');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _fetchCupos() async {
    if (selectedHorario?.id != null) {
      setState(() => isLoading = true);
      try {
        final data = await cupoService.obtenerCuposPorHorario(selectedHorario!.id!);
        setState(() => cupos = data);
      } catch (e) {
        print('Error al cargar cupos: $e');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _reservarCupo(Cupo cupo) async {
    try {
      if (cupo.id == null) throw Exception('El ID del cupo no puede ser nulo');
      await cupoService.reservarCupo(cupo.id!, {
        'asegurado': {'id': 1}, // Reemplaza con el ID del asegurado autenticado
        'estado': 'Ocupado',
        'fechaReservado': DateTime.now().toIso8601String().split('T')[0],
      });
      await _fetchCupos();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cupo reservado correctamente.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al reservar el cupo: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar Cupo'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Sidebar(), // Agregando el sidebar
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Dropdown de Especialidad
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<Especialidad>(
                        decoration: InputDecoration(
                          labelText: "Seleccione una Especialidad",
                          border: InputBorder.none,
                        ),
                        value: selectedEspecialidad,
                        isExpanded: true,
                        items: especialidades.map((especialidad) {
                          return DropdownMenuItem(
                            value: especialidad,
                            child: Text(especialidad.nombre),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedEspecialidad = value;
                            selectedMedico = null;
                            selectedHorario = null;
                            medicos = [];
                            horarios = [];
                            cupos = [];
                          });
                          _fetchMedicos();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Dropdown de Médicos
                  if (medicos.isNotEmpty)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<Medico>(
                          decoration: InputDecoration(
                            labelText: "Seleccione un Médico",
                            border: InputBorder.none,
                          ),
                          value: selectedMedico,
                          isExpanded: true,
                          items: medicos.map((medico) {
                            return DropdownMenuItem(
                              value: medico,
                              child: Text('${medico.usuario?.nombre} ${medico.usuario?.apellido}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedMedico = value;
                              selectedHorario = null;
                              horarios = [];
                              cupos = [];
                            });
                            _fetchHorarios();
                          },
                        ),
                      ),
                    ),
                  SizedBox(height: 16),

                  // Dropdown de Horarios
                  if (horarios.isNotEmpty)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<Horario>(
                          decoration: InputDecoration(
                            labelText: "Seleccione un Horario",
                            border: InputBorder.none,
                          ),
                          value: selectedHorario,
                          isExpanded: true,
                          items: horarios.map((horario) {
                            return DropdownMenuItem(
                              value: horario,
                              child: Text('${horario.fecha} - ${horario.horaInicio} a ${horario.horaFinal}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedHorario = value;
                              cupos = [];
                            });
                            _fetchCupos();
                          },
                        ),
                      ),
                    ),
                  SizedBox(height: 16),

                  // Lista de Cupos
                  if (cupos.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: cupos.length,
                        itemBuilder: (context, index) {
                          final cupo = cupos[index];
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                            child: ListTile(
                              leading: Icon(
                                Icons.event_seat,
                                color: cupo.estado == 'Libre' ? Colors.green : Colors.red,
                              ),
                              title: Text('Cupo ${cupo.numero}'),
                              subtitle: Text('Estado: ${cupo.estado} - Hora: ${cupo.hora}'),
                              trailing: cupo.estado == 'Libre'
                                  ? ElevatedButton(
                                      onPressed: () => _reservarCupo(cupo),
                                      child: Text('Reservar'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
