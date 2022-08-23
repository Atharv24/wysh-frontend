import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

const Color backgroundColor = Color(0xffFFFEFE);
const Color trendGradientStartColor = Color(0xffF9F6EF);
const Color trendGradientEndColor = Color(0xffFFFFFF);
const Color logoColor = Color(0xff2D2C2D);
const Color subheadingColor = Color(0xff888888);
const Color basePriceColor = Color(0xff888888);
const Color currentPriceColor = Color(0xffC23D37);

// const Color selectedBottomNavBarColor = Color(0xff)

class ApiConstants {
  static const String baseUrl = 'http://192.168.29.112:8080';
  static const String homeUrl = '/home';
}

class Trend {
  late String? trendName;
  late List<Article>? articles;

  Trend(this.trendName, this.articles);
}

class Article {
  late String? articleName;
  late int? currentPrice;
  late int? basePrice;
  late String? brand;
  late String? imageLink;

  Article(this.articleName, this.currentPrice, this.basePrice, this.brand,
      this.imageLink);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wysh',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Trend> _trends = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.homeUrl);
    var res = await http.get(url);
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      _trends = data.map((e) {
        List<dynamic> articlesObj = e['article'];
        List<Article> articles = articlesObj
            .map((x) => Article(x['article_name'], x['current_price'],
                x['base_price'], x['brand'], x['image_link']))
            .toList();
        return Trend(e['trend_name'], articles);
      }).toList();
      _trends.retainWhere((Trend t) => t.articles?.isNotEmpty ?? false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      body: Column(children: [
        const HeaderWidget(),
        Expanded(
            child: ListView(
          children: _trends.map((Trend t) => TrendWidget(trend: t)).toList(),
        ))
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset('./lib/assets/home.svg'), label: 'home'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('./lib/assets/search.svg'),
              label: 'search'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('./lib/assets/heart.svg'),
              label: 'wishlist')
        ],
        backgroundColor: backgroundColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    ));
  }
}

class TrendWidget extends StatelessWidget {
  late Trend trend;

  TrendWidget({Key? key, required this.trend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 382,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [trendGradientStartColor, trendGradientEndColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(children: [
          Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.centerLeft,
              child: Text(trend.trendName ?? '')),
          SizedBox(
            height: 226,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: trend.articles
                        ?.map((e) => ArticleCard(article: e))
                        .toList() ??
                    []),
          )
        ]));
  }
}

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 130,
        child: Card(
          child: InkWell(
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child:Column(
            children: [
              Image.network("https://${article.imageLink!}",
                      height: 160, fit: BoxFit.fill),
              const SizedBox(height: 8),
              Row(children: [
                if(article.basePrice! > article.currentPrice!) Text(article.basePrice!.toString(), style: const TextStyle(fontSize: 12, color: basePriceColor, decoration: TextDecoration.lineThrough)),
                Text('₹${article.currentPrice!}', style: const TextStyle(fontSize: 14, color: currentPriceColor),)
              ],)
            ],
          ))),
        ));
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        const SizedBox(
            height: 32,
            child: Text(
              "WISH",
              style: TextStyle(
                  color: logoColor, fontSize: 30, fontWeight: FontWeight.w900),
            )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: const Text(
            "Keep scrolling to find all the latest trends from 10+ stores",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: subheadingColor,
                fontWeight: FontWeight.w400,
                fontSize: 16),
          ),
        ),
      ],
    );
  }
}
