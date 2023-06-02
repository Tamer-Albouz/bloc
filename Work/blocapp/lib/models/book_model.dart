class BookModel {
  late final String? id;
  late final String? title;
  late final String? author;

  BookModel.fromJson(dynamic json)
      : id = json['id'],
        title = json['title'],
        author = json['author'];
}
