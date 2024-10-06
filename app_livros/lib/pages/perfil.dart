import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  PerfilPage({required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 100),
            SizedBox(height: 20),
            Text('Nome do Usuário', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Modo Escuro'),
              value: isDarkMode,
              onChanged: (value) => toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}
