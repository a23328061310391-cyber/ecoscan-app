import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../widgets/resultado_card.dart';
import '../models/residuo.dart';

class HistorialScreen extends StatefulWidget {
  @override
  _HistorialScreenState createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Map<String, dynamic>> _historial = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    setState(() => _cargando = true);
    _historial = await _db.getHistorial();
    setState(() => _cargando = false);
  }

  Future<void> _limpiarTodo() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpiar historial'),
        content: Text('¿Eliminar todo el historial?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await _db.limpiarHistorial();
      _cargarHistorial();
    }
  }

  String _formatearFecha(int timestamp) {
    final fecha = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📜 Historial'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          if (_historial.isNotEmpty)
            IconButton(icon: Icon(Icons.delete_sweep), onPressed: _limpiarTodo),
        ],
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator(color: Colors.green))
          : _historial.isEmpty
              ? Center(child: Text('No hay historial aún'))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _historial.length,
                  itemBuilder: (context, index) {
                    final item = _historial[index];
                    final residuo = Residuo(
                      id: item['id'],
                      nombre: item['nombre'],
                      categoria: item['categoria'],
                      contenedor: item['contenedor'],
                      consejo: item['consejo'],
                    );
                    return Column(
                      children: [
                        ResultadoCard(residuo: residuo),
                        Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(_formatearFecha(item['fecha']), style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}