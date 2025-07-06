import 'dart:isolate';

import 'package:collection/collection.dart';
import 'package:cults3d_webscrapper/models/cults_item.dart';
import 'package:cults3d_webscrapper/models/cults_url_item.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

final List<CultsUrlItem> _urls = [
  CultsUrlItem(
    'Foo',
    'https://cults3d.com/en/design-collections/ManabunLab/low-poly-magnet-puzzle',
  ),
];

Future<List<CultsItem>> scrapeItemsCults3D(
  List<CultsUrlItem> urlItemsList,
) async {
  final urls = urlItemsList.map((e) => e.url).toList();
  final responses = await Isolate.run<List<http.Response>>(
    () => getPages(urls),
  );

  if (responses.isEmpty) {
    print('No data');
    return [];
  }

  List<CultsItem> items = [];

  try {
    for (http.Response response in responses) {
      if (response.statusCode == 200) {
        final title = response.request!.url.origin + response.request!.url.path;
        Map<String, dynamic> item = {'title': title};
        final document = await Isolate.run<Document>(
          () => html.parse(response.body),
        );

        final productInfo = document.querySelector(
          '.product__infos .button_to .btn-third',
        );
        if (productInfo != null) {
          final price = extractNumericValue(productInfo.text, hasDecimal: true);
          item['price'] = price;
        }

        final docs = document.getElementsByClassName('icon-and-text');

        for (String type in ['views', 'likes', 'downloads']) {
          final data = docs
              .firstWhereOrNull((element) => element.innerHtml.contains(type))
              ?.nodes;

          if (data != null) {
            final valueString = extractNumericValue(
              (data.last as Text).data.trim(),
            );

            item[type] = valueString;
          }
        }

        items.add(CultsItem.fromMap(item));
      } else {
        print('Erro ao acessar a página. Código: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Erro ao fazer scraping: $e');
  }

  return items;
}

num extractNumericValue(String text, {bool hasDecimal = false}) {
  final match = RegExp(r'[\d.]+').firstMatch(text);
  if (match == null) return hasDecimal ? 0.0 : 0;

  final list = text.split(" ");
  final value = list.first;

  final lastChar = value[value.length - 1];
  final hasSuffix = RegExp(r'[kKmM]').hasMatch(lastChar);

  double number = double.parse(match.group(0)!);

  if (hasSuffix) {
    switch (lastChar.toLowerCase()) {
      case 'k':
        number *= 1000;
        break;
      case 'm':
        number *= 1000000;
        break;
    }
  }

  return hasDecimal ? number : number.toInt();
}

Future<List<http.Response>> getPages(List<String> urls) async {
  if (urls.isEmpty) return [];

  List<Future<http.Response>> requests = [];
  for (var url in urls) {
    requests.add(http.get(Uri.parse(url)));
  }

  final responses = await Future.wait(requests);
  return responses;
}

void main() async {
  print('Start: ${DateTime.now()}\n');

  final items = await scrapeItemsCults3D(_urls);

  items.forEach(print);

  print('\nEnd: ${DateTime.now()}');
}
