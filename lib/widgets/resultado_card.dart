import 'package:flutter/material.dart';
import '../models/residuo.dart';

class ResultadoCard extends StatelessWidget {
  final Residuo residuo;
  const ResultadoCard({Key? key, required this.residuo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: residuo.getColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(residuo.getIcono(), color: residuo.getColor(), size: 32),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(residuo.nombre, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Chip(
                        label: Text(residuo.contenedor, style: TextStyle(color: Colors.white)),
                        backgroundColor: residuo.getColor(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.orange[700]),
                  SizedBox(width: 8),
                  Expanded(child: Text('💡 ${residuo.consejo}')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}