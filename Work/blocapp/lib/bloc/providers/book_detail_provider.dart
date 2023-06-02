import 'package:blocapp/api/api_calls.dart';
import 'package:blocapp/bloc/models/book_model.dart';

class BookDetailProvider {
  Future<BookModel?> getDetailBooks(String id) async {
    final results = await request(path: '/$id', parameters: {});
    final data = results['data'];
    return BookModel.fromJson(data);
  }
}
