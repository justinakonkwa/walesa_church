// ignore_for_file: must_be_immutable, unnecessary_null_comparison, library_private_types_in_public_api

import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:walesa/page/home_page.dart';
import 'package:walesa/widgets/app_text.dart';
import 'package:walesa/widgets/colors.dart';
import 'package:walesa/widgets/lign.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'page/movie_page.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage({Key? key, required this.videoLink, required this.videoTitre})
      : super(key: key);
  String videoLink;
  String videoTitre;
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  String? getBannerAdUnitId() {
    // if (Platform.isIOS) {
    //   return 'ca-app-pub-2698138965577450/3425404109';
    // } else
    if (Platform.isAndroid) {
      return 'ca-app-pub-2698138965577450/9484643471';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (videoItems != null) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoLink)!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contex) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                              child: YoutubePlayer(
                                controller: _controller,
                                showVideoProgressIndicator: true,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.050 * MediaQuery.of(context).size.width,
                            right: 0.88 * MediaQuery.of(context).size.width,
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/home'),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.activColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      sizedbox,
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: AppText(
                          text: widget.videoTitre[0].toUpperCase() +
                              widget.videoTitre.substring(1).toLowerCase(),
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      Lign(
                        indent: MediaQuery.of(context).size.width * 0.15,
                        endIndent: MediaQuery.of(context).size.width * 0.15,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: videoItems.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        children: [
                                          Flex(
                                             direction: Axis.horizontal,
                                            children:[SizedBox(
                                              height: 100,
                                              width: MediaQuery.of(contex)
                                                      .size
                                                      .width *
                                                  0.35,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        videoItems[index]
                                                            .imageUrl),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                              ]),
                                          Positioned(
                                            top: 0.08 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            right: 0.16 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            child: GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                      return VideoPlayerPage(
                                                        videoLink:
                                                            videoItems[index]
                                                                .videoId,
                                                        videoTitre:
                                                            videoItems[index]
                                                                .title,
                                                      );
                                                    }),
                                                    (route) => false,
                                                  );
                                                });
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          AppColors.activColor,
                                                    ),
                                                    shape: BoxShape.circle,
                                                    color: Colors.transparent),
                                                child: const Icon(
                                                  Icons.play_arrow,
                                                  size: 20,
                                                  color: AppColors.activColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 80.0,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: Text(
                                                videoItems[index].title,
                                                style: const TextStyle(),
                                                maxLines: 2,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              child: AppText(
                                                text: videoItems[index]
                                                    .uploadDate,
                                                color: Theme.of(context)
                                                    .focusColor,
                                                size: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Lign(
                                    indent: MediaQuery.of(context).size.width *
                                        0.15,
                                    endIndent:
                                        MediaQuery.of(context).size.width *
                                            0.15,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  AdmobBanner(
                    adUnitId: getBannerAdUnitId()!,
                    adSize: AdmobBannerSize.BANNER,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
