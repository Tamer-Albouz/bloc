import 'package:blocapp/cubit/books_list_cubit.dart';
import 'package:blocapp/providers/books_list_provider.dart';
import 'package:blocapp/repos/books_list_repository.dart';
import 'package:blocapp/states/books_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetails extends StatelessWidget {
  final String id;
  const BookDetails({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BooksListCubit(book: BooksListRepository(BooksListProvider())),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text("Book Details",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          elevation: 0,
        ),
        body: Center(
          child: BlocBuilder<BooksListCubit, BooksListState>(
            builder: (context, state) {
              if (state.status == ResultStatus.initial) {
                context.read<BooksListCubit>().getDetailBooks(id);
                return const Center(
                  child: Text(
                    "No data",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              } else if (state.status == ResultStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.status == ResultStatus.failure) {
                return Center(
                  child: Text(state.error!,
                      style: const TextStyle(color: Colors.white)),
                );
              }
              return Column(
                children: [
                  Text(state.model![0].title!),
                  Text(state.model![0].author!),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
