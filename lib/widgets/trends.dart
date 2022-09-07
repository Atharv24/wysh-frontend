import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wysh/constants/spacing.dart';

import '../constants/api_constants.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import 'article.dart';
import 'back_button.dart';

class Trend {
  late int id;
  late String? trendName;
  late List<Article>? articles;

  Trend(this.id, this.trendName, this.articles);
}

class TrendWidget extends StatelessWidget {
  final Trend trend;

  const TrendWidget({Key? key, required this.trend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [trendGradientStartColor, trendGradientEndColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        alignment: Alignment.centerLeft,
        child: Text(trend.trendName ?? '',
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: 0.8)),
      ),
      SizedBox(
        height: 310,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            List<Widget> rowElements = [
              const SizedBox(width: 16),
              ArticleCard(article: trend.articles![index])
            ];
            if (index == trend.articles!.length - 1) {
              rowElements.add(const SizedBox(width: 16));
            }
            return Row(children: rowElements);
          },
          itemCount: trend.articles?.length ?? 0,
        ),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => TrendScreen(
                        id: trend.id,
                        name: trend.trendName!,
                      ))),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  foregroundColor: blackColor,
                  side: const BorderSide(color: blackColor),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero))),
              child: const Text(
                "EXPLORE TREND",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 1),
              ))),
      const SizedBox(
        height: 16,
      )
    ]));
  }
}

class TrendScreen extends StatefulWidget {
  final int id;
  final String name;

  const TrendScreen({
    required this.id,
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  State<TrendScreen> createState() => _TrendScreenState();
}

class _TrendScreenState extends State<TrendScreen> {
  late final Trend _trend = Trend(widget.id, widget.name, []);

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(children: [
        Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: titleBorderColor))),
          child: AppBar(
            toolbarHeight: 64,
            elevation: 0,
            backgroundColor: backgroundColor,
            titleTextStyle: bodyTitleTextStyle,
            leading: const BackTopBarButton(),
            title: Text("TIE DYE".toUpperCase()),
            centerTitle: true,
          ),
        ),
        Expanded(
            child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _trend.articles!.length,
                gridDelegate: articleGridDelegate,
                itemBuilder: (context, index) {
                  var article = _trend.articles![index];
                  return ArticleCard(
                      article: Article(article.id, article.title, 1000, 1100,
                          article.brand, article.imageUrl));
                }))
      ]),
    );
  }

  void _getData() async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getTrendUrl(widget.id));
    var res = await get(url);
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body)['articles'];
      setState(() {
        _trend.articles = data
            .map((x) => Article(x['id'], x['title'], x['current_price'],
                x['base_price'] + 1, x['brand'], null))
            .toList();
      });
    }
  }
}
