import 'package:flutter/material.dart';
import 'package:app_livros/pages/livros.dart';
import 'package:app_livros/pages/favoritos.dart';
import 'package:app_livros/pages/perfil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Livros',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LivrosPage(toggleTheme: _toggleTheme),
        '/favorites': (context) => FavoritosPage(),
        '/perfil': (context) => PerfilPage(toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
      },
    );
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }
}
