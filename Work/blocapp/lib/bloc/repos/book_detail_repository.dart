import 'package:blocapp/bloc/models/book_model.dart';
import 'package:blocapp/bloc/providers/book_detail_provider.dart';
import 'package:blocapp/bloc/repos/interfaces/book_detail_repository_interface.dart';

class BookDetailRepository implements BookDetailRepositoryInterface {
  final BookDetailProvider _bookDetailProvider;
  const BookDetailRepository(BookDetailProvider bookDetailProvider)
      : _bookDetailProvider = bookDetailProvider;

  @override
  Future<BookModel?> getBookDetail(String id) async {
    return await _bookDetailProvider.getDetailBooks(id);
  }
}
