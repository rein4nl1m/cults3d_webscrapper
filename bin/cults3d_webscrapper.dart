// ignore_for_file: avoid_relative_lib_imports
import 'package:cults3d_webscrapper/models/cults_item.dart';

import '../lib/cults3d_items_webscrapper.dart' as items;
import '../lib/cults3d_collection_webscrapper.dart' as collection;

final _baseUrl = "https://cults3d.com";
final _path = "/en/design-collections/ManabunLab/low-poly-magnet-puzzle";

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
      printTopNItems(items: items, param: 'views');
      print('\nPer Likes');
      printTopNItems(items: items, param: 'likes');
      print('\nPer Downloads');
      printTopNItems(items: items, param: 'downloads');
      print('\nPer Price');
      printTopNItems(items: items, param: 'price', range: 10);

      getTopN(items: items, range: 10);
    });
  });
}

void printTopNItems(
    {required List<CultsItem> items, required String param, int range = 5}) {
  if (param == "price") {
    items.sort((a, b) =>
        (a.toMap()[param] as double).compareTo(b.toMap()[param] as double));
  } else {
    items.sort((a, b) => b.toMap()[param] - a.toMap()[param]);
  }

  final itemsInRange = items.take(range);
  for (var e in itemsInRange) {
    print(e.toStringPerParam(param));
  }

  if (param == "price") {
    final total = itemsInRange
        .map((e) => e.price)
        .reduce((value, element) => value + element)
        .ceilToDouble();

    print('Total: R\$ $total');
  }
}

void getTopN({required List<CultsItem> items, int range = 5}) {
  print('\nTop $range Per All (downloads > views > likes > price)');
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
  final top5 = items.take(range);
  top5.forEach(print);

  final total = top5
      .map((e) => e.price)
      .reduce((value, elemnet) => value + elemnet)
      .ceilToDouble();

  print('Total: R\$ $total');
}
