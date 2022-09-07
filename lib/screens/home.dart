import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:wysh/provider/wishlist.dart';

import '../constants/api_constants.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../widgets/article.dart';
import '../widgets/header.dart';
import '../widgets/trends.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomeScreen extends StatelessWidget {
  final List<Trend> _trends;

  const HomeScreen({
    Key? key,
    required List<Trend> trends,
  })  : _trends = trends,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const HeaderWidget(),
      Expanded(
          child: ListView(
        children: _trends.map((Trend t) => TrendWidget(trend: t)).toList(),
      ))
    ]);
  }
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WishListModel wishlistProvider = Provider.of<WishListModel>(context);
    return Container(
      color: backgroundColor,
      child: Column(children: [
        const SizedBox(height: 4),
        Container(
            alignment: Alignment.center,
            height: 56,
            child: const Text(
              "WYSHLIST",
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: 0.8),
            )),
        Expanded(
          child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: wishlistProvider.favArticles.length,
              gridDelegate: articleGridDelegate,
              itemBuilder: (context, index) =>
                  ArticleCard(article: wishlistProvider.favArticles[index])),
        ),
      ]),
    );
  }
}

class HomePageState extends State<HomePage> {
  late List<Trend> _trends = [];
  int pageIndex = 0;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => switchTab(0, _navigatorKey),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
            child: ChangeNotifierProvider(
                create: (context) => WishListModel(),
                child: Navigator(
                  key: _navigatorKey,
                  initialRoute: '/home',
                  onGenerateRoute: (routeSettings) {
                    switch (routeSettings.name) {
                      case '/home':
                        return MaterialPageRoute(
                            builder: (context) => HomeScreen(trends: _trends));
                      case '/search':
                        return MaterialPageRoute(
                          builder: (context) => const Center(
                              child: Text("Search coming soon...")),
                        );
                      case '/wishlist':
                        return MaterialPageRoute(
                            builder: (context) => const WishlistScreen());
                      default:
                        return MaterialPageRoute(
                            builder: (context) => HomeScreen(trends: _trends));
                    }
                  },
                ))),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: pageIndex,
          onTap: (int index) => switchTab(index, _navigatorKey),
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset('./lib/assets/home.svg'),
                activeIcon: SvgPicture.asset("./lib/assets/home-filled.svg"),
                label: 'home'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('./lib/assets/search.svg'),
                activeIcon: SvgPicture.asset('./lib/assets/search-filled.svg'),
                label: 'search'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('./lib/assets/heart.svg'),
                activeIcon: SvgPicture.asset('./lib/assets/heart-filled.svg'),
                label: 'wishlist')
          ],
          backgroundColor: backgroundColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  bool switchTab(int index, GlobalKey<NavigatorState> navigatorKey) {
    if (index == pageIndex && index == 0) {
      _navigatorKey.currentState!.popUntil((route) => route.isFirst);
      return false;
    }
    if (index == pageIndex) return true;
    switch (index) {
      case 0:
        _navigatorKey.currentState!.pushReplacementNamed('/home');
        break;
      case 1:
        _navigatorKey.currentState!.pushReplacementNamed('/search');
        break;
      case 2:
        _navigatorKey.currentState!.pushReplacementNamed('/wishlist');
        break;
      default:
        _navigatorKey.currentState!
            .pushReplacementNamed(Navigator.defaultRouteName);
        break;
    }
    setState(() {
      pageIndex = index;
    });
    return false;
  }

  void _getData() async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.homeUrl);
    var res = await get(url);
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body)['trends'];
      _trends = data.map((e) {
        List<dynamic> articlesObj = e['articles'];
        List<Article> articles = articlesObj
            .map((x) => Article(x['id'], x['title'], x['current_price'],
                x['base_price'] + 1, x['brand'], x['image_url']))
            .toList();
        return Trend(e['id'], e['title'], articles);
      }).toList();
      _trends.retainWhere((Trend t) => t.articles?.isNotEmpty ?? false);
    }
  }
}
