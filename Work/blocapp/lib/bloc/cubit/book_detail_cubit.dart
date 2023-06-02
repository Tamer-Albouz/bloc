import 'package:blocapp/bloc/repos/book_detail_repository.dart';
import 'package:blocapp/bloc/states/book_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailCubit extends Cubit<BookDetailState> {
  final BookDetailRepository _book;

  BookDetailCubit({required BookDetailRepository book})
      : _book = book,
        super(const BookDetailState(model: null, status: ResultStatus.initial));

  Future<void> getBookDetail(String id) async {
    try {
      emit(state.copyWith(status: ResultStatus.submitting));
      final model = await _book.getBookDetail(id);
      emit(state.copyWith(status: ResultStatus.success, model: model));
    } catch (e) {
      emit(state.copyWith(status: ResultStatus.failure, error: e.toString()));
    }
  }
}
