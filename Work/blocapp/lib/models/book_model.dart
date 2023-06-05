class BookModel {
  late final String? title;
  late final String? author;
  late final String? partitionKey;
  late final String? rowKey;
  late final String? timestamp;
  late final String? eTag;

  BookModel.fromJson(dynamic json)
      : title = json['title'],
        author = json['author'],
        partitionKey = json['partitionKey'],
        rowKey = json['rowKey'],
        timestamp = json['timestamp'],
        eTag = json['eTag'];
}
