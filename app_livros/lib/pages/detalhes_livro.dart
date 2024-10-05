import 'package:flutter/material.dart';
import 'package:app_livros/db_livros.dart';

class DetalhesLivroPage extends StatelessWidget {
  final Map<String, dynamic> book;
  final DBLivros dbLivros = DBLivros();

  DetalhesLivroPage({required this.book});

  @override
  Widget build(BuildContext context) {
    String title = book['volumeInfo']['title'] ?? 'Título desconhecido';
    String description = book['volumeInfo']['description'] ?? 'Descrição indisponível';
    String authors = (book['volumeInfo']['authors'] as List<dynamic>?)?.join(', ') ?? 'Autor desconhecido';
    String thumbnail = book['volumeInfo']['imageLinks']?['thumbnail'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () async {
              bool exists = await dbLivros.bookExists(book['id']);
              if (!exists) {
                await dbLivros.insertBook({
                  'id': book['id'],
                  'title': title,
                  'authors': authors,
                  'description': description,
                  'thumbnail': thumbnail,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title adicionado aos favoritos!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title já está nos favoritos!')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (thumbnail.isNotEmpty)
              Image.network(thumbnail),
            SizedBox(height: 10),
            Text(
              'Título: $title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Autores: $authors', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Descrição:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(description),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
