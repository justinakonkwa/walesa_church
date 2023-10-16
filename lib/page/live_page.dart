// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, must_be_immutable

import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import '../widgets/app_text.dart';
import '../widgets/app_text_large.dart';
import '../widgets/colors.dart';
import '../widgets/lign.dart';
import 'home_page.dart';

bool isUser = false;
List _videos2 = [];
List liveVideos = [];

class LivePage extends StatefulWidget {
  LivePage({Key? key, required this.videoUrl, required this.videoTitre})
      : super(key: key);
  String videoUrl;
  String videoTitre;

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  late YoutubePlayerController _controller;
  final String apiKey = 'AIzaSyBOGBdLgmfyTj2H3IZUYA_NVRQUtxnpsfc';
  bool isError = false;
  bool isLive = false;
  bool isLoading = true;
  String titre = '';
  bool isVideos = false;

  Future<void> _scrapeYouTube() async {
    setState(() {
      if (mounted) {
        isLoading = true;
      }
    });
    try {
      final videoResponse = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UC39gOLqu1MFXJfCw-SRwGJQ&maxResults=100&order=date&type=video&key=$apiKey'));

      final videoItems = json.decode(videoResponse.body)['items'];
      final videos = videoItems
          .map((item) => Video(
              item['snippet']['title'],
              item['snippet']['channelTitle'],
              item['snippet']['publishedAt'],
              item['snippet']['thumbnails']['default']['url'],
              'https://www.youtube.com/watch?v=${item['id']['videoId']}',
              item['snippet']['liveBroadcastContent'] == 'live'))
          .toList();
      setState(() {
        setState(() => isError = false);
        _videos2 = [];
        _videos2.addAll(videos);
        liveVideos = _videos2.where((video) => video.isLive).toList();
      });
      if (liveVideos.isNotEmpty) {
        titre = liveVideos[0].title;
        _controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(liveVideos[0].url)!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
        setState(() {
          isLoading = true;
          titre;
          isLive = true;
        });
        // view();
      } else {
        setState(() {
          if (mounted) {
            isLoading = false;
          }
        });
      }
    } catch (e) {
      setState(() {
        if (mounted) {
          isLoading = false;
          isError = true;
        }
      });
      // ignore: avoid_print
      print(e);
    }
  }

  String? getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2698138965577450/3425404109';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2698138965577450/3866180785';
    }
    return null;
  }

  @override
  void initState() {
    _scrapeYouTube();
    if (widget.videoUrl != '') {
      titre = widget.videoTitre;
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      );
      isVideos = true;
    }
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
              alignment: Alignment.centerLeft,
              child: AppTextLarge(
                text: 'En direct',
                size: 30,
                color: Theme.of(context).disabledColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              alignment: Alignment.centerLeft,
              child: AppTextLarge(
                text: 'Walesa',
                size: 20,
                color: AppColors.activColor,
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              isLive || isVideos
                                  ? YoutubePlayer(
                                      controller: _controller,
                                      showVideoProgressIndicator: true,
                                      progressIndicatorColor:
                                          AppColors.activColor,
                                      onReady: () {
                                        isLive ? _controller.pause() : null;
                                      },
                                    )
                                  : Container(
                                      color: const Color(0xFF454444),
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Center(
                                          child: !isLoading
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.cloud_off_rounded,
                                                      size: 30,
                                                      color:
                                                          AppColors.mainColor,
                                                    ),
                                                    AppText(
                                                      text:
                                                          "Pas de diffusion directe",
                                                      color:
                                                          AppColors.mainColor,
                                                    ),
                                                    sizedbox,
                                                    GestureDetector(
                                                      onTap: () {
                                                        _scrapeYouTube();
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .mainColor,
                                                          borderRadius:
                                                              borderRadius,
                                                        ),
                                                        child: AppText(
                                                          text: "Actualiser",
                                                          color: const Color(
                                                              0x8D000000),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : const Icon(
                                                  Icons.cached_outlined,
                                                  color: AppColors.mainColor,
                                                ),
                                        ),
                                      ),
                                    ),
                              Positioned(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    isLive && widget.videoUrl == ''
                                        ? Container(
                                            padding: const EdgeInsets.all(4),
                                            margin: const EdgeInsets.only(
                                                right: 10, top: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: AppColors.poweroffColor),
                                            child: AppText(
                                                text: "En direct",
                                                color: AppColors.mainColor),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            ],
                          ),
                          sizedbox,
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: AppText(
                              text: isLive || isVideos
                                  ? titre[0].toUpperCase() + titre.substring(1)
                                  : "Aucune video en direct",
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          const Lign(indent: 0, endIndent: 0),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _videos2.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, right: 20, bottom: 10),
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: borderRadius,
                                  color: Theme.of(context).focusColor,
                                  // boxShadow:  [
                                  //   BoxShadow(
                                  //     color: Theme.of(context).cardColor,
                                  //     blurRadius: 10,
                                  //     offset: const Offset(0, 3),
                                  //   ),
                                  // ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Builder(builder: (context) {
                                      return InkWell(
                                        onTap: () async {
                                          setState(() {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return HomePage(
                                                  currentIndex: 1,
                                                  videoUrl: _videos2[index].url,
                                                  videoTitre:
                                                      _videos2[index].title,
                                                );
                                              }),
                                              (route) => false,
                                            );
                                          });
                                        },
                                        child: Image.network(
                                          _videos2[index].image,
                                          width: 100,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          frameBuilder:
                                              (_, image, loadingBuilder, __) {
                                            if (loadingBuilder == null) {
                                              return const SizedBox(
                                                width: 100,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      AppColors.activColor,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return image;
                                          },
                                          loadingBuilder: (BuildContext context,
                                              Widget image,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return image;
                                            }
                                            return SizedBox(
                                              width: 100,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, e, ___) =>
                                              Center(
                                            child: Center(
                                              child: Icon(
                                                Icons.report_problem,
                                                size: 35,
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 180,
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            _videos2[index]
                                                    .title[0]
                                                    .toUpperCase() +
                                                _videos2[index]
                                                    .title
                                                    .substring(1),
                                            style: TextStyle(
                                                color: titre ==
                                                        _videos2[index].title
                                                    ? AppColors.activColor
                                                    : Theme.of(context)
                                                        .disabledColor,
                                                fontSize: 16,
                                                fontFamily: 'Nunito',
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 0),
                                            softWrap: false,
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis, // new
                                          ),
                                        ),
                                        sizedbox,
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: AppText(
                                            text:
                                                "${_videos2[index].date.toString().substring(0, _videos2[index].date.toString().length - 10)} à ${_videos2[index].date.toString().substring(11, _videos2[index].date.toString().length - 4)}",
                                            color:
                                                Theme.of(context).disabledColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: AppText(
                                            text: _videos2[index].author,
                                            color: Theme.of(context).cardColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return HomePage(
                                                currentIndex: 1,
                                                videoUrl: _videos2[index].url,
                                                videoTitre:
                                                    _videos2[index].title,
                                              );
                                            }),
                                            (route) => false,
                                          );
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0x8D000000),
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: AppColors.mainColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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

  // view() async {
  //   var date = DateTime.now();
  //   String dateFormat = DateFormat('EEEE').format(date);

  //   String uid = '';
  //   if (titre.length > 700) {
  //     uid = titre.substring(0, 700).replaceAll(RegExp("[.#/|\$|-]"), '');
  //   } else {
  //     uid = titre.replaceAll(RegExp("[.#/|\$|-]"), '');
  //   }

  //   final databaseReference = FirebaseDatabase.instance.reference();
  //   await databaseReference
  //       .child('playMovie')
  //       .child(paroisse.replaceAll(RegExp("[.#/|\$|-]"), ''))
  //       .child(dateFormat)
  //       .child(uuid.replaceAll(RegExp("[.#/|\$|-]"), '') +
  //           uid.replaceAll(RegExp("[;&|[|]|]"), ''))
  //       .set({
  //         'uid': uid,
  //       })
  //       .then((value) => print("video vue"))
  //       .catchError((error) {
  //         print(error.toString());
  //       });
  // }
}

class Video {
  final String title;
  final String author;
  final String date;
  final String image;
  final String url;
  final bool isLive;

  Video(this.title, this.author, this.date, this.image, this.url, this.isLive);
}
