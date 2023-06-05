import 'package:blocapp/models/book_model.dart';
import 'package:blocapp/providers/books_provider.dart';
import 'package:blocapp/repos/interfaces/books_repository_interface.dart';

class BooksRepository implements BooksRepositoryInterface {
  final BooksProvider _booksListProvider;
  const BooksRepository(BooksProvider booksListProvider)
      : _booksListProvider = booksListProvider;

  @override
  Future<List<BookModel>?> getBooks() async {
    return await _booksListProvider.getBooks();
  }

  @override
  Future<void> patchBook(String id, body) async {
    return await _booksListProvider.patchBook(id, body);
  }

  @override
  Future<String?> deleteBook(String id) async {
    return await _booksListProvider.deleteBook(id);
  }

  @override
  Future<void> postBook(body) async {
    return await _booksListProvider.postBook(body);
  }
}
