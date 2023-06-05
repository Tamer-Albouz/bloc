import 'package:blocapp/repos/books_repository.dart';
import 'package:blocapp/states/books_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksListCubit extends Cubit<BooksListState> {
  final BooksRepository _book;

  BooksListCubit({required BooksRepository book})
      : _book = book,
        super(const BooksListState(model: null, status: ResultStatus.initial));

  // Emit failure state
  void emitFailure() =>
      emit(state.copyWith(status: ResultStatus.failure, model: null));

  Future<void> getBooks() async {
    try {
      emit(state.copyWith(status: ResultStatus.loading));
      final model = await _book.getBooks();
      emit(state.copyWith(status: ResultStatus.success, model: model));
    } catch (e) {
      emit(state.copyWith(status: ResultStatus.failure, error: e.toString()));
    }
  }

  Future<void> patchBook(String id, body) async {
    try {
      emit(state.copyWith(status: ResultStatus.loading));
      await _book.patchBook(id, body);
      final model = await _book.getBooks();
      emit(state.copyWith(status: ResultStatus.success, model: model));
    } catch (e) {
      emit(state.copyWith(status: ResultStatus.failure, error: e.toString()));
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      emit(state.copyWith(status: ResultStatus.loading));
      await _book.deleteBook(id);
      final model = await _book.getBooks();
      emit(state.copyWith(status: ResultStatus.success, model: model));
    } catch (e) {
      emit(state.copyWith(status: ResultStatus.failure, error: e.toString()));
    }
  }

  Future<void> postBook(body) async {
    try {
      emit(state.copyWith(status: ResultStatus.loading));
      await _book.postBook(body);
      final model = await _book.getBooks();
      emit(state.copyWith(status: ResultStatus.success, model: model));
    } catch (e) {
      emit(state.copyWith(status: ResultStatus.failure, error: e.toString()));
    }
  }
}
