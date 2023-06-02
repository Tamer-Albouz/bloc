import 'dart:async';
import 'dart:convert' show json;

import 'package:blocapp/models/book_model.dart';
import 'package:http/http.dart' as http;

class BooksListProvider {
  final _host = '';
  final _contextRoot = '';

  Future<List<BookModel>?> getBooks() async {
    final results = await request(path: '', parameters: {});
    return results['data']
        .map<BookModel>(BookModel.fromJson)
        .toList(growable: false);
  }

  Future<BookModel?> getDetailBooks(String id) async {
    final results = await request(path: '/$id', parameters: {});
    final data = results['data'];
    return BookModel.fromJson(data);
  }

  Future<Map> request({
    required String path,
    required Map<String, Object> parameters,
  }) async {
    final uri = Uri.https(_host, '$_contextRoot/$path', parameters);
    final headers = _headers;
    final results = await http.get(uri, headers: headers);
    final jsonObject = json.decode(results.body);
    return jsonObject;
  }

  Map<String, String> get _headers => {
        'content-type': 'application/vnd.api+json; charset=utf-8',
        'Accept': 'application/json',
      };
}
