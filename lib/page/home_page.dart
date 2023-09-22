// ignore_for_file: must_be_immutable, avoid_print, body_might_complete_normally_catch_error, deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:walesa/page/live_page.dart';
import 'package:walesa/page/movie_page.dart';
import 'package:walesa/widgets/colors.dart';


BorderRadius borderRadius = BorderRadius.circular(10);
SizedBox sizedbox = const SizedBox(height: 10);
SizedBox sizedbox2 = const SizedBox(width: 10);

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
    this.currentIndex = 0,
    this.videoUrl ='',
    this.videoTitre = '',


  });
  int currentIndex;
  String videoUrl ;
  String videoTitre;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          initialIndex:widget.currentIndex,
          length: 2,
          child: Stack(alignment: Alignment.bottomCenter, children: [
            TabBarView(
              children: [
                const VideoPage(),
                LivePage(videoTitre: widget.videoTitre, videoUrl: widget.videoUrl),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1,
                      offset: Offset(1, 4), // Shadow position
                    ),
                  ],
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: ClipPath(
                  clipper: const ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: AppColors.activColor,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    mouseCursor: MouseCursor.uncontrolled,
                    indicatorColor: Theme.of(context).focusColor,
                    labelColor: Theme.of(context).focusColor,
                    unselectedLabelColor: Theme.of(context).focusColor,
                    tabs:  const [
                      Tab(
                        child: Icon(
                          Icons.home,
                          size: 30,
                          // color: Theme.of(context).hintColor,
                        ),
                      ),
                      Tab(
                        child: Icon(
                          Icons.live_tv,
                          size: 30,
                          // color:Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
