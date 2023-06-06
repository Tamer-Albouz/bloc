import 'package:blocapp/cubit/books_cubit.dart';
import 'package:blocapp/pages/add_book_page.dart';
import 'package:blocapp/states/books_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.title});

  final String title;

  final TextEditingController _editTitleController = TextEditingController();
  final TextEditingController _editAuthorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<BooksCubit, BooksState>(
          builder: (context, state) => AppBar(
            backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
            title: Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: IconButton(
                  onPressed: () {
                    context.read<BooksCubit>().getBooks();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: IconButton(
                  onPressed: () {
                    context.read<BooksCubit>().emitFailure();
                  },
                  icon: const Icon(Icons.error),
                ),
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: BlocConsumer<BooksCubit, BooksState>(
          listenWhen: (previous, current) {
            return previous.status != current.status;
          },
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
              context.read<BooksCubit>().getBooks();
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    color: const Color.fromRGBO(20, 20, 20, 1),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 55,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green)),
                            onPressed: () {
                              // post a book with json body
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: BlocProvider.of<BooksCubit>(context),
                                    child: AddBook(
                                      currentContext: context,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Add A Book",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextField(
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search Book Title...",
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
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.model!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
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
                            trailing: IconButton(
                              onPressed: () {
                                // Show alert dialog
                                showDialog(
                                  context: context,
                                  builder: (_) {
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
                                            "Cancel",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                            context
                                                .read<BooksCubit>()
                                                .deleteBook(state
                                                    .model![index].rowKey!);
                                          },
                                          child: const Text(
                                            "Delete",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete_outlined,
                                size: 28,
                                color: Colors.red,
                              ),
                            ),
                            onTap: () {
                              // Show alert dialog
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: BlocProvider.of<BooksCubit>(context),
                                    child: AlertDialog(
                                      backgroundColor: Colors.grey[900]!,
                                      title: const Text(
                                        "Edit Book",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: SizedBox(
                                        height: 150,
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: _editTitleController,
                                              cursorColor: Colors.white,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                hintText: "Enter Book Title",
                                                hintStyle: const TextStyle(
                                                    color: Colors.white70),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.white38,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            TextField(
                                              controller: _editAuthorController,
                                              cursorColor: Colors.white,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                hintText: "Enter Book Author",
                                                hintStyle: const TextStyle(
                                                    color: Colors.white70),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.white38,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text(
                                            "Cancel",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                            context
                                                .read<BooksCubit>()
                                                .patchBook(
                                                    state.model![index].rowKey!,
                                                    <String, String>{
                                                  "title":
                                                      _editTitleController.text,
                                                  "author":
                                                      _editAuthorController
                                                          .text,
                                                });
                                            _editTitleController.clear();
                                            _editAuthorController.clear();
                                          },
                                          child: const Text(
                                            "Update",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
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
    );
  }
}
