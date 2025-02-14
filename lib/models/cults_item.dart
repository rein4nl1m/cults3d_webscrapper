class CultsItem {
  final String title;
  final int views;
  final int likes;
  final int downloads;

  CultsItem({
    required this.title,
    required this.views,
    required this.likes,
    required this.downloads,
  });

  factory CultsItem.fromMap(Map<String, dynamic> map) {
    return CultsItem(
      title: map['title'] as String,
      views: map['views'] as int,
      likes: map['likes'] as int,
      downloads: map['downloads'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'views': views,
      'likes': likes,
      'downloads': downloads,
    };
  }

  @override
  String toString() {
    return 'CultsItem(title: $title, views: $views, likes: $likes, downloads: $downloads)';
  }

  String toStringPerParam(String param) {
    switch (param) {
      case 'views':
        return 'CultsItem(title: $title, views: $views)';
      case 'likes':
        return 'CultsItem(title: $title, likes: $likes)';
      case 'downloads':
        return 'CultsItem(title: $title, downloads: $downloads)';
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
        other.downloads == downloads;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        views.hashCode ^
        likes.hashCode ^
        downloads.hashCode;
  }

  CultsItem copyWith({
    String? title,
    int? views,
    int? likes,
    int? downloads,
  }) {
    return CultsItem(
      title: title ?? this.title,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      downloads: downloads ?? this.downloads,
    );
  }
}
