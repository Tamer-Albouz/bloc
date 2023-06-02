import 'package:blocapp/models/book_model.dart';

abstract class BooksListRepositoryInterface {
  Future<List<BookModel>?> getBooks();
  Future<BookModel?> getDetailBooks(String id);
}
