import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../widgets/resultado_card.dart';
import '../models/residuo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Residuo> _resultados = [];
  bool _cargando = false;

  Future<void> _buscar() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingresa un residuo para buscar')),
      );
      return;
    }

    setState(() => _cargando = true);
    try {
      final resultados = await _db.buscar(_controller.text);
      setState(() => _resultados = resultados);
      
      if (resultados.isNotEmpty) {
        await _db.guardarHistorial(resultados.first.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Guardado en historial'), duration: Duration(seconds: 1)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontró "${_controller.text}"')),
        );
      }
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('♻️ EcoScan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '🔍 Ej: botella, lata, pila...',
                suffixIcon: IconButton(icon: Icon(Icons.search, color: Colors.green[700]), onPressed: _buscar),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (_) => _buscar(),
            ),
            SizedBox(height: 16),
            if (_cargando)
              Center(child: CircularProgressIndicator(color: Colors.green))
            else if (_resultados.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _resultados.length,
                  itemBuilder: (context, index) => ResultadoCard(residuo: _resultados[index]),
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.recycling, size: 64, color: Colors.green[300]),
                      SizedBox(height: 16),
                      Text('¡Hola! 👋', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Busca un residuo para aprender a reciclarlo'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}