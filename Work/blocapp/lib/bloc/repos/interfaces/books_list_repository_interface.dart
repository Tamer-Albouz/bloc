import 'package:blocapp/bloc/models/book_model.dart';

abstract class BooksListRepositoryInterface {
  Future<List<BookModel>?> getBooks();
}
