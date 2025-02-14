import 'dart:isolate';

import 'package:cults3d_webscrapper/models/cults_url_item.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

Future<List<CultsUrlItem>> scrapeCollectionCults3D(String collectionUrl) async {
  List<CultsUrlItem> urlItemsList = [];
  final response = await http.get(Uri.parse(collectionUrl));

  if (response.statusCode == 200) {
    final baseUrl = response.request!.url.origin;
    final document = await Isolate.run(() async {
      final data = html.parse(response.body);
      return data;
    });

    final data = document.querySelectorAll('article');
    for (var article in data) {
      final String url =
          article.children.first.children.first.attributes['href'] ?? "";

      final String title =
          article.children.first.children.first.attributes['title'] ?? "";

      if (url.isNotEmpty) urlItemsList.add(CultsUrlItem(title, '$baseUrl$url'));
    }
  }

  return urlItemsList;
}

void main() async {
  final url =
      "https://cults3d.com/en/design-collections/ManabunLab/low-poly-magnet-puzzle";
  final urlItems = await scrapeCollectionCults3D(url);
  urlItems.forEach(print);
}
