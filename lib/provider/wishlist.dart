import 'dart:collection';

import 'package:flutter/material.dart';

import '../widgets/article.dart';

class WishListModel extends ChangeNotifier {
  final List<Article> _favArticles = [];

  UnmodifiableListView<Article> get favArticles =>
      UnmodifiableListView(_favArticles);

  void add(Article article) {
    _favArticles.add(article);
    notifyListeners();
  }

  void remove(int id) {
    _favArticles.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
