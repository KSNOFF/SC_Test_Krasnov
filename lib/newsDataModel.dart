// ignore_for_file: file_names

class News {
  final dynamic id;
  final dynamic name;
  final dynamic image;
  final dynamic date;
  final dynamic description;

  const News({
    required this.id,
    required this.name,
    required this.image,
    required this.date,
    required this.description,
  });

  static News fromJson(json) => News(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      date: json["date"],
      description: json["description"]);
}
