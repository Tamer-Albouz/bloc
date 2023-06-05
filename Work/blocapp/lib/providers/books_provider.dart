import 'dart:async';
import 'dart:convert' show json;
import '../config.dart';

import 'package:blocapp/models/book_model.dart';
import 'package:http/http.dart' as http;

class BooksProvider {
  final _host = 'moeydemo.azure-api.net';

  Future<List<BookModel>?> getBooks() async {
    final results = await request(path: 'books/books', parameters: {});
    return results.map<BookModel>(BookModel.fromJson).toList(growable: false);
  }

  Future<void> patchBook(String id, body) async {
    await patch(path: 'books/books/$id', parameters: {}, body: body);
  }

  Future<String?> deleteBook(String id) async {
    final results = await delete(path: 'books/books/$id', parameters: {});
    return results;
  }

  Future<void> postBook(body) async {
    await post(path: 'books/books', parameters: {}, body: body);
  }

  // Get request
  Future<List> request({
    required String path,
    required Map<String, Object> parameters,
  }) async {
    final uri = Uri.https(_host, path, parameters);
    final headers = _headers;
    final results = await http.get(uri, headers: headers);

    return results.body.isEmpty ? [] : json.decode(results.body);
  }

  // Patch request
  Future<void> patch({
    required String path,
    required Map<String, Object> parameters,
    required Map<String, Object> body,
  }) async {
    final uri = Uri.https(_host, path, parameters);
    final headers = _headers;
    final results = await http.patch(
      uri,
      headers: headers,
      body: json.encode(body),
    );

    return results.body.isEmpty ? [] : json.decode(results.body);
  }

  // Delete request
  Future<String> delete({
    required String path,
    required Map<String, Object> parameters,
  }) async {
    final uri = Uri.https(_host, path, parameters);
    final headers = _headers;
    final results = await http.delete(uri, headers: headers);

    return results.body.isEmpty ? "" : results.body;
  }

  // Post request
  Future<void> post({
    required String path,
    required Map<String, Object> parameters,
    required Map<String, Object> body,
  }) async {
    final uri = Uri.https(_host, path, parameters);
    final headers = {
      'Accept': '*/*',
      "Ocp-Apim-Subscription-Key": apiKey,
    };
    final result = await http.post(
      uri,
      headers: headers,
      body: json.encode(body),
    );

    print("Post: ${result.statusCode != 200 ? "Failed" : "Successful"}");
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        "Ocp-Apim-Subscription-Key": apiKey,
      };
}
