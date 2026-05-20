import 'package:flutter/material.dart';

class Residuo {
  final int id;
  final String nombre;
  final String categoria;
  final String contenedor;
  final String consejo;

  Residuo({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.contenedor,
    required this.consejo,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'categoria': categoria,
    'contenedor': contenedor,
    'consejo': consejo,
  };

  factory Residuo.fromMap(Map<String, dynamic> map) => Residuo(
    id: map['id'],
    nombre: map['nombre'],
    categoria: map['categoria'],
    contenedor: map['contenedor'],
    consejo: map['consejo'],
  );

  Color getColor() {
    if (contenedor == 'Amarillo') return Colors.amber;
    if (contenedor == 'Verde') return Colors.green;
    if (contenedor == 'Azul') return Colors.blue;
    if (contenedor == 'Marron') return Colors.brown;
    if (contenedor == 'Punto limpio') return Colors.red;
    return Colors.grey;
  }

  IconData getIcono() {
    if (categoria == 'plastico') return Icons.water_damage;
    if (categoria == 'vidrio') return Icons.wine_bar;
    if (categoria == 'organico') return Icons.eco;
    if (categoria == 'papel') return Icons.description;
    if (categoria == 'metal') return Icons.build;
    if (categoria == 'peligroso') return Icons.warning;
    return Icons.recycling;
  }
}