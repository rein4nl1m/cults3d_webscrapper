// ignore_for_file: avoid_relative_lib_imports
import 'package:cults3d_webscrapper/models/cults_item.dart';

import '../lib/cults3d_items_webscrapper.dart' as items;
import '../lib/cults3d_collection_webscrapper.dart' as collection;

final _baseUrl = "https://cults3d.com";
final _path = "/en/design-collections/ManabunLab/low-poly-magnet-puzzle";

void printTop3Items(List<CultsItem> items, String param) {
  items.sort((a, b) => b.toMap()[param] - a.toMap()[param]);
  items.take(3).forEach((e) => print(e.toStringPerParam(param)));
}

void main(List<String> arguments) async {
  final url = _baseUrl + _path; //arguments.first;

  collection.scrapeCollectionCults3D(url).then((itemUrls) async {
    items.scrapeItemsCults3D(itemUrls).then((items) {
      print('\nPer Views');
      printTop3Items(items, 'views');
      print('\nPer Likes');
      printTop3Items(items, 'likes');
      print('\nPer Downloads');
      printTop3Items(items, 'downloads');

      print('\nTop 3 Per All');
      items.sort(
        (a, b) {
          int viewsComparison = b.views.compareTo(a.views);
          if (viewsComparison != 0) return viewsComparison;

          int likesComparison = b.likes.compareTo(a.likes);
          if (likesComparison != 0) return likesComparison;

          return b.downloads.compareTo(a.downloads);
        },
      );
      items.take(3).forEach(print);
    });
  });
}
