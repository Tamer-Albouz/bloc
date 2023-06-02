import 'package:blocapp/bloc/models/book_model.dart';

enum ResultStatus { initial, submitting, success, failure }

class BookDetailState {
  final BookModel? model;
  final ResultStatus? status;
  final String? error;
  const BookDetailState({
    this.model,
    this.status,
    this.error,
  });

  BookDetailState copyWith({
    BookModel? model,
    ResultStatus? status,
    String? error,
  }) {
    return BookDetailState(
      model: model ?? this.model,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
