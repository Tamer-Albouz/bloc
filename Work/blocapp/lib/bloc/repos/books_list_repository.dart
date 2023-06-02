import 'package:blocapp/bloc/models/book_model.dart';
import 'package:blocapp/bloc/providers/books_list_provider.dart';
import 'package:blocapp/bloc/repos/interfaces/books_list_repository_interface.dart';

class BooksListRepository implements BooksListRepositoryInterface {
  final BooksListProvider _booksListProvider;
  const BooksListRepository(BooksListProvider booksListProvider)
      : _booksListProvider = booksListProvider;

  @override
  Future<List<BookModel>?> getBooks() async {
    return await _booksListProvider.getBooks();
  }
}
