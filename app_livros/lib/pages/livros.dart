import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_livros/db_livros.dart';
import 'package:app_livros/pages/detalhes_livro.dart';

class LivrosPage extends StatefulWidget {
  @override
  _LivrosPageState createState() => _LivrosPageState();
}

class _LivrosPageState extends State<LivrosPage> {
  final TextEditingController _searchController = TextEditingController();
  final DBLivros dbLivros = DBLivros();
  List<dynamic> books = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          books = data['items'] ?? [];
          if (books.isEmpty) {
            _errorMessage = 'Nenhum livro encontrado.';
          }
        });
      } else {
        setState(() {
          _errorMessage = 'Erro ao carregar os livros.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao conectar com a API.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bookify'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Digite o título ou autor',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (query) {
                _searchBooks(query);
                _searchController.clear();
              },
            ),
            SizedBox(height: 20),
            if (_isLoading) CircularProgressIndicator(),
            if (_errorMessage.isNotEmpty) Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
            ),
            Expanded(
              child: books.isEmpty && !_isLoading
                  ? Center(child: Text('Nenhum livro encontrado.'))
                  : ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  var book = books[index]['volumeInfo'];
                  return ListTile(
                    leading: book['imageLinks'] != null
                        ? Image.network(book['imageLinks']['thumbnail'])
                        : Icon(Icons.book),
                    title: Text(book['title'] ?? 'Título indisponível'),
                    subtitle: Text(book['authors']?.join(', ') ?? 'Autor desconhecido'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesLivroPage(book: books[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
