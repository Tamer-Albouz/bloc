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
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
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
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500)),
          elevation: 0,
        ),
        body: Center(
          child: BlocConsumer<BooksListCubit, BooksListState>(
            listener: (context, state) => const CircularProgressIndicator(
              color: Colors.white,
            ),
            builder: (context, state) {
              if (state.status == ResultStatus.submitting) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              }
              return ListView.builder(
                itemCount: state.model?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      state.model?[index].attributes?.name ?? '',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      state.model?[index].attributes?.description ?? '',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
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
