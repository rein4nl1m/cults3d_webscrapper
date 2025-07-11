class CultsItem {
  final String title;
  final int views;
  final int likes;
  final int downloads;
  final double price;

  CultsItem({
    required this.title,
    required this.views,
    required this.likes,
    required this.downloads,
    required this.price,
  });

  double get likesPerView => (likes / views).ceilToDouble();

  factory CultsItem.fromMap(Map<String, dynamic> map) {
    return CultsItem(
      title: map['title'] as String,
      views: map['views'] as int? ?? 0,
      likes: map['likes'] as int? ?? 0,
      downloads: map['downloads'] as int? ?? 0,
      price: map['price'] as double? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'views': views,
      'likes': likes,
      'downloads': downloads,
      'price': price,
    };
  }

  @override
  String toString() {
    return 'CultsItem(title: $title, views: $views, likes: $likes, downloads: $downloads, price: $price)';
  }

  String toStringPerParam(String param) {
    switch (param) {
      case 'views':
        return 'CultsItem(title: $title, views: $views)';
      case 'likes':
        return 'CultsItem(title: $title, likes: $likes)';
      case 'downloads':
        return 'CultsItem(title: $title, downloads: $downloads)';
      case 'price':
        return 'CultsItem(title: $title, price: $price)';
      default:
        return toString();
    }
  }

  @override
  bool operator ==(covariant CultsItem other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.views == views &&
        other.likes == likes &&
        other.downloads == downloads &&
        other.price == price;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        views.hashCode ^
        likes.hashCode ^
        downloads.hashCode ^
        price.hashCode;
  }
}
