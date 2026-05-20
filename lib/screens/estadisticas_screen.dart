import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class EstadisticasScreen extends StatefulWidget {
  @override
  _EstadisticasScreenState createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  int _total = 0;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarEstadisticas();
  }

  Future<void> _cargarEstadisticas() async {
    setState(() => _cargando = true);
    _total = await _db.getTotal();
    setState(() => _cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📊 Estadísticas'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator(color: Colors.green))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.recycling, size: 80, color: Colors.green),
                  SizedBox(height: 20),
                  Text('Total de clasificaciones:', style: TextStyle(fontSize: 18)),
                  Text(
                    '$_total',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 20),
                  if (_total > 0)
                    Text('¡Sigue así! Estás ayudando al planeta 🌍', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
    );
  }
}