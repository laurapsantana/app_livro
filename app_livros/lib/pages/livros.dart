import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_livros/db_livros.dart';
import 'package:app_livros/pages/detalhes_livro.dart';

class LivrosPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  LivrosPage({required this.toggleTheme});

  @override
  _LivrosPageState createState() => _LivrosPageState();
}

class _LivrosPageState extends State<LivrosPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> books = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool isGridView = false;

  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=${query.trim()}'));

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
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.nightlight_round),
            onPressed: widget.toggleTheme,
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
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
              ),
            Expanded(
              child: books.isEmpty && !_isLoading
                  ? Center(child: Text('Bem-vindo(a)! Pesquise livros acima.'))
                  : isGridView
                  ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  var book = books[index]['volumeInfo'];
                  return _buildBookCard(book);
                },
              )
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/favorites');
          if (index == 2) Navigator.pushNamed(context, '/perfil');
        },
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesLivroPage(book: book),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Expanded(
              child: book['imageLinks'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.network(
                  book['imageLinks']['thumbnail'],
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(Icons.book, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                book['title'] ?? 'Título indisponível',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Text(book['authors']?.join(', ') ?? 'Autor desconhecido'),
          ],
        ),
      ),
    );
  }
}
