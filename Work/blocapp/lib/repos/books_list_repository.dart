import 'package:blocapp/models/book_model.dart';
import 'package:blocapp/providers/books_list_provider.dart';
import 'package:blocapp/repos/interfaces/books_list_repository_interface.dart';

class BooksListRepository implements BooksListRepositoryInterface {
  final BooksListProvider _booksListProvider;
  const BooksListRepository(BooksListProvider booksListProvider)
      : _booksListProvider = booksListProvider;

  @override
  Future<List<BookModel>?> getBooks() async {
    return await _booksListProvider.getBooks();
  }

  @override
  Future<BookModel?> getDetailBooks(String id) async {
    return await _booksListProvider.getDetailBooks(id);
  }
}
