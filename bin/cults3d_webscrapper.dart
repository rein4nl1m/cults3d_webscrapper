// ignore_for_file: avoid_relative_lib_imports
import 'package:cults3d_webscrapper/models/cults_item.dart';

import '../lib/cults3d_items_webscrapper.dart' as items;
import '../lib/cults3d_collection_webscrapper.dart' as collection;

final _baseUrl = "https://cults3d.com";
final _path = "/en/design-collections/ManabunLab/low-poly-magnet-puzzle";

void printTopNItems(List<CultsItem> items, String param, [int range = 5]) {
  if (param == "price") {
    items.sort((a, b) =>
        (a.toMap()[param] as double).compareTo(b.toMap()[param] as double));
  } else {
    items.sort((a, b) => b.toMap()[param] - a.toMap()[param]);
  }
  items.take(range).forEach((e) => print(e.toStringPerParam(param)));
}

void main(List<String> arguments) async {
  String url = "";
  if (arguments.isNotEmpty) {
    url = arguments[0] + arguments[1];
  } else {
    url = _baseUrl + _path;
  }

  collection.scrapeCollectionCults3D(url).then((itemUrls) async {
    items.scrapeItemsCults3D(itemUrls).then((items) {
      print('\nPer Views');
      printTopNItems(items, 'views');
      print('\nPer Likes');
      printTopNItems(items, 'likes');
      print('\nPer Downloads');
      printTopNItems(items, 'downloads');
      print('\nPer Price');
      printTopNItems(items, 'price');

      print('\nTop 5 Per All (downloads > views > likes > price)');
      items.sort(
        (a, b) {
          int downloadsComparison = b.downloads.compareTo(a.downloads);
          if (downloadsComparison != 0) return downloadsComparison;

          int viewsComparison = b.views.compareTo(a.views);
          if (viewsComparison != 0) return viewsComparison;

          int likesComparison = b.likes.compareTo(a.likes);
          if (likesComparison != 0) return likesComparison;

          return a.price.compareTo(b.price);
        },
      );
      items.take(5).forEach(print);
    });
  });
}
