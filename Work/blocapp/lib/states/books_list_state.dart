import 'package:blocapp/models/book_model.dart';

enum ResultStatus { initial, loading, success, failure }

class BooksListState {
  final List<BookModel>? model;
  final ResultStatus? status;
  final String? error;
  const BooksListState({
    this.model,
    this.status,
    this.error,
  });

  BooksListState copyWith({
    List<BookModel>? model,
    ResultStatus? status,
    String? error,
  }) {
    return BooksListState(
      model: model ?? this.model,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
