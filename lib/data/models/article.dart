class Article {
  final String title;
  final String description;
  final String content;
  final String url;
  final String urlToImage;

  Article({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.urlToImage,
  });

  // Фабричный метод для преобразования JSON в объект Article
  factory Article.fromJson(Map<String, dynamic> json) => Article(
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    content: json['content'] ?? '',
    url: json['url'] ?? '',
    urlToImage: json['urlToImage'] ?? '',
  );

  // Метод для преобразования объекта Article обратно в JSON
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'content': content,
    'url': url,
    'urlToImage': urlToImage,
  };
}
