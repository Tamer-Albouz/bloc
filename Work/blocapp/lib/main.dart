import 'dart:ui';

import 'package:blocapp/cubit/books_list_cubit.dart';
import 'package:blocapp/providers/books_list_provider.dart';
import 'package:blocapp/repos/books_list_repository.dart';
import 'package:blocapp/states/books_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLoC Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: "Nunito"),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter BLoC Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          title: Text(widget.title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500)),
          elevation: 0,
        ),
        body: Center(
          child: BlocBuilder<BooksListCubit, BooksListState>(
            builder: (context, state) {
              if (state.status == ResultStatus.initial) {
                context.read<BooksListCubit>().getBooks();
                return const Text(
                  "No data",
                  style: TextStyle(color: Colors.white),
                );
              } else if (state.status == ResultStatus.loading) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              } else if (state.status == ResultStatus.failure) {
                return Text(
                  state.error ?? '',
                  style: const TextStyle(color: Colors.white),
                );
              }
              return ListView.builder(
                itemCount: state.model!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      tileColor: const Color.fromRGBO(45, 45, 45, 1),
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      title: Text(
                        state.model![index].title!,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        state.model![index].author!,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
