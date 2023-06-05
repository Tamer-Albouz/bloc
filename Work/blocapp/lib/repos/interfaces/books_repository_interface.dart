import 'package:blocapp/models/book_model.dart';

abstract class BooksRepositoryInterface {
  Future<List<BookModel>?> getBooks();
  Future<void> patchBook(String id, body);
  Future<String?> deleteBook(String id);
  Future<void> postBook(body);
}
