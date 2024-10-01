import 'package:flutter/material.dart';
import 'package:app_livros/pages/livros.dart';
import 'package:app_livros/pages/favoritos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Livros',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LivrosPage(),
        '/favorites': (context) => FavoritosPage(),
      },
    );
  }
}
