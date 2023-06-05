import 'package:blocapp/cubit/books_list_cubit.dart';
import 'package:blocapp/providers/books_provider.dart';
import 'package:blocapp/repos/books_repository.dart';
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
      title: 'BLoC Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: "Nunito"),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'BLoC Demo'),
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
  final TextEditingController _titleController = TextEditingController();

  void handleSubmit(String id) {
    if (_titleController.text.isNotEmpty) {
      context.read<BooksListCubit>().patchBook(id, <String, String>{
        "title": _titleController.text,
      });

      _titleController.clear();

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BooksListCubit(book: BooksRepository(BooksProvider())),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: BlocBuilder<BooksListCubit, BooksListState>(
            builder: (context, state) => AppBar(
              backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
              title: Text(widget.title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: IconButton(
                    onPressed: () {
                      context.read<BooksListCubit>().getBooks();
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: IconButton(
                    onPressed: () {
                      context.read<BooksListCubit>().emitFailure();
                    },
                    icon: const Icon(Icons.error),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Center(
          child: BlocConsumer<BooksListCubit, BooksListState>(
            listener: (context, state) {
              if (state.status == ResultStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Oh No! Something went wrong!"),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              } else if (state.status == ResultStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Success!"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 1),
                  ),
                );
              } else if (state.status == ResultStatus.loading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Loading..."),
                    backgroundColor: Colors.blue,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.status == ResultStatus.initial) {
                context.read<BooksListCubit>().getBooks();
                // Timer.periodic(const Duration(seconds: 15), (timer) {
                //   // Make an API request to fetch the latest data
                //   context.read<BooksListCubit>().getBooks();
                // });

                return const Text(
                  "No data",
                  style: TextStyle(color: Colors.white),
                );
              } else if (state.status == ResultStatus.loading) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              } else if (state.status == ResultStatus.failure) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "${state.error}",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextField(
                            controller: _titleController,
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Enter Book Title",
                              hintStyle: const TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.white38,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green)),
                              onPressed: () {
                                // post a book with json body
                                context
                                    .read<BooksListCubit>()
                                    .postBook(<String, String>{
                                  "title": _titleController.text,
                                  "author": "John Doe"
                                });
                                _titleController.clear();
                              },
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.model!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Dismissible(
                              background: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              confirmDismiss: (direction) {
                                return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.grey[900]!,
                                      title: const Text(
                                        "Delete Book",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: const Text(
                                        "Are you sure you want to delete this book?",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text(
                                            "No",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text(
                                            "Yes",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              key: Key(state.model![index].id!),
                              onDismissed: (direction) {
                                context
                                    .read<BooksListCubit>()
                                    .deleteBook(state.model![index].id!);
                              },
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                tileColor: const Color.fromRGBO(45, 45, 45, 1),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                title: Text(
                                  state.model![index].title!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  state.model![index].author!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                onTap: () {},
                                trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditBookPage(
                                          book: state.model![index].id!,
                                          state: state,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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

class EditBookPage extends StatefulWidget {
  final String book;
  final BooksListState state;
  const EditBookPage({super.key, required this.book, required this.state});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final TextEditingController _editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BooksListCubit(book: BooksRepository(BooksProvider())),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
        appBar: AppBar(
          title: const Text("Edit Book", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
          elevation: 0,
        ),
        body: BlocBuilder<BooksListCubit, BooksListState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _editController,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter Book Title",
                      hintStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white38,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () {
                      context
                          .read<BooksListCubit>()
                          .patchBook(widget.book, <String, String>{
                        "title": _editController.text,
                      });

                      _editController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text("Edit Book"),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
