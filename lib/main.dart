import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

const Color articleNameColor = Color(0xff888888);
const Color backgroundColor = Color(0xffFFFEFE);
const Color basePriceColor = Color(0xff888888);
const Color blackColor = Color(0xff2D2C2D);
const Color currentPriceColor = Color(0xffC23D37);
const Color imageCardBorderColor = Color(0xfff4f3f1);
const Color imageCardColor = Color(0xffFBFAF9);
const Color subheadingColor = Color(0xff888888);
const Color trendGradientEndColor = Color(0xffFFFFFF);

const Color trendGradientStartColor = Color(0xffF9F6EF);

// const Color selectedBottomNavBarColor = Color(0xff)

class ApiConstants {
  static const String baseUrl = 'http://localhost:8080';

  // static const String baseUrl = 'http://192.168.29.112:8080';
  static const String homeUrl = '/home';
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

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: GestureDetector(
          onTap: () => {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: imageCardColor,
                      border: Border.all(color: imageCardBorderColor),
                      borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.all(8),
                  child: Image.network("https://${article.imageLink!}",
                      fit: BoxFit.fill)),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (article.basePrice! > article.currentPrice!)
                    Text('₹${article.basePrice!}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: basePriceColor,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.lineThrough)),
                  Text(
                    '₹${article.currentPrice!}',
                    style: const TextStyle(
                        fontSize: 14,
                        color: currentPriceColor,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  SvgPicture.asset('./lib/assets/heart.svg', height: 20)
                ],
              ),
              const SizedBox(height: 2),
              Text(article.brand!,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: blackColor)),
              const SizedBox(height: 2),
              Text(article.articleName!,
                  style: const TextStyle(
                      color: articleNameColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.visible)
            ],
          )),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 32,
            child: Text(
              "WYSH",
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                      color: blackColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -3.15)),
              // style: TextStyle(
              //     color: blackColor, fontSize: 30, fontWeight: FontWeight.w900, fontFamily: GoogleFonts),
            )),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Text(
              "Keep scrolling to find all the latest trends from 10+ stores",
              textAlign: TextAlign.center,
              style: GoogleFonts.cabin(
                  textStyle: const TextStyle(
                      color: subheadingColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16))),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
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

class Trend {
  late String? trendName;
  late List<Article>? articles;

  Trend(this.trendName, this.articles);
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
          padding: const EdgeInsets.all(24),
          alignment: Alignment.centerLeft,
          child: Text(trend.trendName ?? '',
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 20))),
      SizedBox(
        height: 276,
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
              onPressed: () => {},
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  primary: blackColor,
                  side: const BorderSide(color: blackColor),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero))),
              child: const Text(
                "EXPLORE TREND",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ))),
      const SizedBox(
        height: 16,
      )
    ]));
  }
}

class _HomePageState extends State<HomePage> {
  late List<Trend> _trends = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(children: [
          const HeaderWidget(),
          Expanded(
              child: ListView(
            children: _trends.map((Trend t) => TrendWidget(trend: t)).toList(),
          ))
        ]),
      ),
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
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.homeUrl);
    var res = await http.get(url);
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body)['trends'];
      _trends = data.map((e) {
        List<dynamic> articlesObj = e['article'];
        List<Article> articles = articlesObj
            .map((x) => Article(x['article_name'], x['current_price'],
                x['base_price'] + 1, x['brand'], x['image_link']))
            .toList();
        return Trend(e['trend_name'], articles);
      }).toList();
      _trends.retainWhere((Trend t) => t.articles?.isNotEmpty ?? false);
    }
  }
}
