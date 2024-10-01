import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://www.googleapis.com/books/v1/volumes?q=';

  Future<List<dynamic>> fetchBooks(String query) async {
    final response = await http.get(Uri.parse(baseUrl + query));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['items'] ?? [];
    } else {
      throw Exception('Falha ao carregar os livros');
    }
  }
}
