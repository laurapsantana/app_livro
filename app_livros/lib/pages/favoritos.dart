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
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    List<Map<String, dynamic>> books = await dbLivros.getBooks();
    setState(() {
      favoriteBooks = books;
    });
  }

  Future<void> _deleteBook(String id) async {
    await dbLivros.deleteBook(id);
    await _loadFavorites(); // Recarrega a lista de favoritos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Livro removido dos favoritos!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
      ),
      body: favoriteBooks.isEmpty
          ? Center(child: Text('Nenhum livro salvo'))
          : ListView.builder(
        itemCount: favoriteBooks.length,
        itemBuilder: (context, index) {
          var book = favoriteBooks[index];
          return ListTile(
            leading: (book['thumbnail'] != null && book['thumbnail'] != '')
                ? Image.network(book['thumbnail'])
                : Icon(Icons.book),
            title: Text(book['title'] ?? 'Título desconhecido'),
            subtitle: Text(book['authors'] != null && book['authors'] is String
                ? book['authors']
                : 'Autor desconhecido'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesLivroPage(book: book),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteBook(book['id']);
              },
            ),
          );
        },
      ),
    );
  }
}
