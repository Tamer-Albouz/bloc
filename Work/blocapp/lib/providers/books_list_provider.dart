import 'dart:async';
import 'dart:convert' show json;
import '../config.dart';

import 'package:blocapp/models/book_model.dart';
import 'package:http/http.dart' as http;

class BooksListProvider {
  final _host = 'moeydemo.azure-api.net';

  Future<List<BookModel>?> getBooks() async {
    final results = await request(path: 'books/books', parameters: {});
    return results.map<BookModel>(BookModel.fromJson).toList(growable: false);
  }

  Future<BookModel?> getDetailBooks(String id) async {
    final results = await request(path: '/$id', parameters: {});
    return BookModel.fromJson(results);
  }

  Future<List> request({
    required String path,
    required Map<String, Object> parameters,
  }) async {
    final uri = Uri.https(_host, path, parameters);
    final headers = _headers;
    final results = await http.get(uri, headers: headers);

    return results.body.isEmpty ? [] : json.decode(results.body);
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        "Ocp-Apim-Subscription-Key": apiKey,
      };
}
