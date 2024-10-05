import 'package:flutter/material.dart';
import 'package:app_livros/db_livros.dart';
import 'package:app_livros/pages/detalhes_livro.dart';

class FavoritosPage extends StatefulWidget {
  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final DBLivros dbLivros = DBLivros();
  List<Map<String, dynamic>> favoriteBooks = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteBooks();
  }

  Future<void> _loadFavoriteBooks() async {
    List<Map<String, dynamic>> books = await dbLivros.getBooks();
    setState(() {
      favoriteBooks = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livros Favoritos'),
      ),
      body: favoriteBooks.isEmpty
          ? Center(child: Text('Nenhum livro favorito.'))
          : ListView.builder(
        itemCount: favoriteBooks.length,
        itemBuilder: (context, index) {
          var book = favoriteBooks[index];
          return ListTile(
            leading: book['thumbnail'] != null
                ? Image.network(book['thumbnail'])
                : Icon(Icons.book),
            title: Text(book['title']),
            subtitle: Text(book['authors']),
            onTap: () {
              // Navega para a página de detalhes passando os dados do livro
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesLivroPage(
                    book: {
                      'id': book['id'],
                      'volumeInfo': {
                        'title': book['title'],
                        'authors': book['authors'].split(', '),
                        'description': book['description'],
                        'imageLinks': {'thumbnail': book['thumbnail']}
                      }
                    },
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await dbLivros.deleteBook(book['id']);
                _loadFavoriteBooks();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${book['title']} removido dos favoritos!')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
