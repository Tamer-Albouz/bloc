import 'package:blocapp/bloc/models/book_model.dart';

abstract class BookDetailRepositoryInterface {
  Future<BookModel?> getBookDetail(String id);
}
