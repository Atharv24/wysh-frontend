import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wysh/provider/wishlist.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';
import 'back_button.dart';

class Article {
  late int? id;
  late String? title;
  late int? currentPrice;
  late int? basePrice;
  late String? brand;
  late String? imageUrl;

  Article(this.id, this.title, this.currentPrice, this.basePrice, this.brand,
      this.imageUrl);
}

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  ArticleDetailScreen(article: article))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: imageCardColor,
                      border: Border.all(color: imageCardBorderColor),
                      borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    color: backgroundColor,
                    child: Hero(
                      tag: "ArticleImage",
                      child: Image.network(article.imageUrl ?? "https://picsum.photos/400/500",
                          // child: Image.network(widget.article.imageUrl!,
                          fit: BoxFit.contain,
                          height: 200,
                          width: 160),
                    ),
                  )),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (article.basePrice! > article.currentPrice!)
                    Text('₹${article.basePrice!}', style: basePriceStyle),
                  Text(
                    ' ₹${article.currentPrice!}',
                    style: currentPriceStyle,
                  ),
                  const Spacer(),
                  FavIcon(article: article),
                ],
              ),
              const SizedBox(height: 2),
              Text(article.brand!,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: blackColor)),
              const SizedBox(height: 2),
              Text(article.title!,
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

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({required this.article, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Hero(
            tag: "ArticleImage",
            child: Container(
              color: backgroundColor,
              child: Image.network(article.imageUrl ?? "https://picsum.photos/400/500",
                  fit: BoxFit.contain, width: MediaQuery.of(context).size.width, height: 400),
            ),
          ),
          Container(
            color: backgroundColor,
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Text("BONKERS", style: bodyTitleTextStyle),
                const Spacer(),
                FavIcon(article: article, size: 28)
              ]),
              const SizedBox(height: 8),
              const Text(
                "Oversized Ocean Tie Dye",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: articleNameColor),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "₹${article.basePrice!}",
                    style: basePriceStyle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "₹${article.currentPrice!}",
                    style: currentPriceStyle.copyWith(fontSize: 16),
                  )
                ],
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ]),
        const Positioned(top: 0, left: 0, child: BackTopBarButton()),
        const Positioned(bottom: 16, left: 16, child: GoToWebsiteButton())
      ],
    );
  }
}

class GoToWebsiteButton extends StatelessWidget {
  const GoToWebsiteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 48,
        width: MediaQuery.of(context).size.width - 32,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 0, backgroundColor: goToWebsiteColor,
            shape: const RoundedRectangleBorder(),
            minimumSize: const Size(double.infinity, double.infinity),
          ),
          child: const Text(
            "GO TO WEBSITE",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 2),
          ),
        ));
  }
}

class FavIcon extends StatelessWidget {
  final Article article;
  final double size;

  const FavIcon({required this.article, this.size = 20, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    WishListModel wishlistProvider = Provider.of<WishListModel>(context);
    bool isFav =
        wishlistProvider.favArticles.map((e) => e.id).contains(article.id);
    return GestureDetector(
      onTap: () => isFav
          ? wishlistProvider.remove(article.id!)
          : wishlistProvider.add(article),
      child: isFav
          ? SvgPicture.asset('./lib/assets/heart-filled.svg', height: size)
          : SvgPicture.asset('./lib/assets/heart.svg', height: size),
    );
  }
}
