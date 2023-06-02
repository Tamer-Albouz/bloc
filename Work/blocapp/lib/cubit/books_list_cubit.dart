import 'package:blocapp/repos/books_list_repository.dart';
import 'package:blocapp/states/books_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksListCubit extends Cubit<BooksListState> {
  final BooksListRepository _book;

  BooksListCubit({required BooksListRepository book})
      : _book = book,
        super(const BooksListState(model: null, status: ResultStatus.initial));

  Future<void> getBooks() async {
    try {
      emit(state.copyWith(status: ResultStatus.submitting));
      final model = await _book.getBooks();
      emit(state.copyWith(status: ResultStatus.success, model: model));
    } catch (e) {
      emit(state.copyWith(status: ResultStatus.failure, error: e.toString()));
    }
  }

  Future<void> getDetailBooks(String id) async {
    try {
      emit(state.copyWith(status: ResultStatus.submitting));
      final model = await _book.getDetailBooks(id);
      emit(state.copyWith(status: ResultStatus.success, model: [model!]));
    } catch (e) {
      emit(state.copyWith(status: ResultStatus.failure, error: e.toString()));
    }
  }
}
