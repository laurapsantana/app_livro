import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List _books = [];
  bool _isLoading = false;

  // Função que busca livros da API (Exemplo usando Google Books API)
  Future<void> _searchBooks(String query) async {
    final apiUrl = 'https://www.googleapis.com/books/v1/volumes?q=$query';

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _books = data['items'] ?? [];
        });
      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na busca: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar livros...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (query) {
                _searchBooks(query);
              },
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: _books.isNotEmpty
                  ? ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  final book = _books[index]['volumeInfo'];
                  return ListTile(
                    title: Text(book['title'] ?? 'Título indisponível'),
                    subtitle: Text(book['authors'] != null
                        ? (book['authors'] as List).join(', ')
                        : 'Autor indisponível'),
                    leading: book['imageLinks'] != null
                        ? Image.network(
                      book['imageLinks']['thumbnail'],
                      width: 50,
                    )
                        : SizedBox(width: 50),
                  );
                },
              )
                  : Center(child: Text('Nenhum livro encontrado.')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}