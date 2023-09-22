// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:walesa/page/home_page.dart';
import 'app_text_large.dart';
import 'colors.dart';


//page qui donne l'annimation des pages secondaire et qui possede l'iconButton de retour
const _maxHeaderExtent = 95.0;
const _minHeaderExtent = 50.0;
const _minTextSize = 22.0;

class ScrollAnimation extends SliverPersistentHeaderDelegate {
  final double _maxTextSize;
  final String title;
  final Color titleColor;
  final String route;
  final int currentIndex;

  ScrollAnimation(this.title, this.route, this.titleColor, this._maxTextSize,
      {this.currentIndex = 0});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / _maxHeaderExtent;
    final currentTextSize =
        (_maxTextSize * (1 - percent)).clamp(_minTextSize, _maxTextSize);
    final leftTextMargin = 30 + (10 * percent);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Stack(children: [
        Positioned(
          height: _maxTextSize + 20,
          child: route != ''
              ? IconButton(
                  iconSize: 35,
                  padding: const EdgeInsets.all(0),
                  color: AppColors.activColor,
                  icon: const Icon(Icons.navigate_before),
                  onPressed: () {
                    currentIndex != 0
                        ? Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                currentIndex: currentIndex,
                              ),
                            ),
                            (route) => false)
                        : Navigator.pushNamedAndRemoveUntil(
                            context, route, (route) => false);
                  },
                )
              : const SizedBox(
                  height: 0,
                  width: 0,
                ),
        ),
        Positioned(
          bottom: currentTextSize - 18,
          left: route != '' ? leftTextMargin : 20,
          height: currentTextSize + 10,
          child: AppTextLarge(
              text: title, size: currentTextSize, color: titleColor),
        ),
      ]),
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _minHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
