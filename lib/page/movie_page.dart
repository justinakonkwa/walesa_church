// ignore_for_file: avoid_print, duplicate_ignore, use_build_context_synchronously

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_version_plus/new_version_plus.dart';
import 'package:provider/provider.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:walesa/page/home_page.dart';
import 'package:walesa/play.dart';
import 'package:walesa/widgets/app_text.dart';
import 'package:walesa/widgets/app_text_large.dart';
import 'package:walesa/widgets/colors.dart';
import 'package:walesa/widgets/lign.dart';
import 'package:walesa/widgets/search_screen.dart';

import '../provider/dark_theme_provider.dart';

List<VideoItem> videoItems = [];
List<VideoItem> loadedVideos = [];

class VideoData {
  static List<VideoItem> loadedVideos = [];
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with WidgetsBindingObserver {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    checkInternetConnectivity();
    final newVersion = NewVersionPlus(
      iOSId: 'com.disney.disneyplus',
      androidId: 'com.communaute.walesa',
      androidPlayStoreCountry: null,
    );

    advancedStatusCheck(newVersion);
    if (VideoData.loadedVideos.isEmpty) {
      fetchVideos().then((videos) {
        if (mounted) {
          setState(() {
            videoItems = videos;
            isLoading = false;
          });
        }
      }).catchError((error) {
        print('Error: $error');
        // Handle fetchVideos error
        if (mounted) {
          setState(() {
            // isLoading = false;
          });
        }
      });
    } else {
      setState(() {
        videoItems = VideoData.loadedVideos;
        isLoading = false;
      });
    }
  }

  advancedStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      // debugPrint(status.releaseNotes);
      // debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      // debugPrint(status.canUpdate.toString());
      if (status.localVersion != status.storeVersion) {
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          updateButtonText: "Installer",
          dismissButtonText: "Plus tard",
          dialogTitle: 'Mise à jour disponible',
          dialogText:
              "Nous sommes ravis de vous présenter la version ${status.localVersion} de notre application, qui apporte de nombreuses améliorations et fonctionnalités par rapport à la version précédente (version ${status.storeVersion})",
          launchModeVersion: LaunchModeVersion.external,
          allowDismissal: true,
        );
      }
    }
  }

  Future<List<VideoItem>> fetchVideos() async {
    var apiKey = 'AIzaSyD-P2V-r6OOqqG1XE7BkyQyhIoa1JP5sDo';
    var channelId = 'UC39gOLqu1MFXJfCw-SRwGJQ';
    var maxResults = 50;

    var apiUrl = 'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=$maxResults&key=$apiKey';
var response = await http.get(Uri.parse(apiUrl));

if (response.statusCode == 200) {
  var data = jsonDecode(response.body);
  var videosData = data['items'];

  // Trier les vidéos par date en utilisant la clé 'publishedAt'
  videosData.sort((a, b) => DateTime.parse(b['snippet']['publishedAt'])
      .compareTo(DateTime.parse(a['snippet']['publishedAt'])));

  var videoItems = videosData
      .take(30) // Sélectionner les 20 premières vidéos
      .map<VideoItem>((video) => VideoItem(
        videoId: video['id']['videoId'] ?? '',
        imageUrl: video['snippet']['thumbnails']['high']['url'] ?? '',
        videoLink: 'https://www.youtube.com/watch?v=${video['id']['videoId']}',
        title: video['snippet']['title'] ?? '',
        uploadDate: video['snippet']['publishedAt'] ?? '',
      ))
      .toList();

  // Afficher les 20 dernières publications de manière ordonnée
  for (var i = 0; i < videoItems.length; i++) {
    var video = videoItems[i];

    print('Titre : ${video.title}');
    print('Date de publication : ${video.uploadDate}');
    print('Lien de la vidéo : ${video.videoLink}');
    print('-----------------------');
  }

  // Enregistrer les vidéos chargées pour une utilisation ultérieure
  VideoData.loadedVideos = videoItems;

  return videoItems;
} else {
  throw Exception('Failed to fetch videos');
}
  }
  // Future<List<VideoItem>> fetchVideos() async {
  //   var apiKey = 'AIzaSyD-P2V-r6OOqqG1XE7BkyQyhIoa1JP5sDo';
  //   var channelId = 'UC39gOLqu1MFXJfCw-SRwGJQ';
  //   var maxResults = 50;

  //   var apiUrl =
  //       'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=$maxResults&key=$apiKey';

  //   var response = await http.get(Uri.parse(apiUrl));

  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     var videosData = data['items'];

  //     // Trier les vidéos par date en utilisant la clé 'publishedAt'
  //     videosData.sort((a, b) => DateTime.parse(b['snippet']['publishedAt'])
  //         .compareTo(DateTime.parse(a['snippet']['publishedAt'])));

  //     var videoItems = videosData
  //         .take(20) // Sélectionner les 10 premières vidéos
  //         .map<VideoItem>((video) => VideoItem(
  //               videoId: video['id']['videoId'] ?? '',
  //               imageUrl: video['snippet']['thumbnails']['high']['url'] ?? '',
  //               videoLink:
  //                   'https://www.youtube.com/watch?v=${video['id']['videoId']}' ??
  //                       '',
  //               title: video['snippet']['title'] ?? '',
  //               uploadDate: video['snippet']['publishedAt'] ?? '',
  //             ))
  //         .toList();

  //     // Enregistrer les vidéos chargées pour une utilisation ultérieure
  //     VideoData.loadedVideos = videoItems;

  //     return videoItems;
  //   } else {
  //     throw Exception('Failed to fetch videos');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isTheme = themeChange.darkTheme;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05,
          left: 10,
          right: 10,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: AppTextLarge(
                        text: 'Walesa Ministries',
                        color: Theme.of(context).hintColor,
                        size: 30,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: AppTextLarge(
                        text: 'Centre de Reveil Spirituel',
                        size: 20,
                        color: AppColors.activColor,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        elevation: 10,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        context: context,
                        builder: (context) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          height: 8,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.activColor),
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppTextLarge(
                                                text: 'Paramètres',
                                                size: 18.0,
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Icon(
                                                  Icons.close,
                                                  color:
                                                      AppColors.poweroffColor,
                                                  size: 30,
                                                ),
                                              )
                                            ]),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          sizedbox,
                                          Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).focusColor,
                                              borderRadius: borderRadius,
                                            ),
                                            child: Column(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    isTheme = !isTheme;
                                                    themeChange.darkTheme =
                                                        isTheme;
                                                    setState(
                                                      () {
                                                        isTheme;
                                                      },
                                                    );
                                                  },
                                                  style: ButtonStyle(
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(0),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      !isTheme
                                                          ? AppText(
                                                              text:
                                                                  'Mode sombre',
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                            )
                                                          : AppText(
                                                              text:
                                                                  'Mode elair',
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                            ),
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .canvasColor,
                                                          borderRadius:
                                                              borderRadius,
                                                        ),
                                                        child: Icon(
                                                          !isTheme
                                                              ? Icons
                                                                  .nights_stay_sharp
                                                              : Icons
                                                                  .light_mode,
                                                          color: Theme.of(
                                                                  context)
                                                              .unselectedWidgetColor,
                                                          size: 20,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Lign(
                                                  indent: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  endIndent:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    propos();
                                                  },
                                                  style: ButtonStyle(
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(0),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all(Theme.of(
                                                                    context)
                                                                .scaffoldBackgroundColor),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppText(
                                                        text: 'À propos',
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .canvasColor,
                                                          borderRadius:
                                                              borderRadius,
                                                        ),
                                                        child: Icon(
                                                          Icons.navigate_next,
                                                          color: Theme.of(
                                                                  context)
                                                              .unselectedWidgetColor,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          sizedbox,
                                          sizedbox,
                                          sizedbox,
                                          Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).focusColor,
                                              borderRadius: borderRadius,
                                            ),
                                            child: Column(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // donner les avis
                                                    StoreRedirect.redirect(
                                                      androidAppId:
                                                          'com.communaute.walesa',
                                                      iOSAppId:
                                                          'com.communaute.walesa',
                                                    );
                                                  },
                                                  style: ButtonStyle(
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(0),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppText(
                                                        text:
                                                            "Evaluer l'application",
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .canvasColor,
                                                          borderRadius:
                                                              borderRadius,
                                                        ),
                                                        child: Icon(
                                                          Icons.navigate_next,
                                                          color: Theme.of(
                                                                  context)
                                                              .unselectedWidgetColor,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Lign(
                                                  indent: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  endIndent:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Dialog(
                                                          child:
                                                              InteractiveViewer(
                                                            panEnabled:
                                                                false, // Désactive le déplacement par glissement
                                                            boundaryMargin:
                                                                const EdgeInsets
                                                                    .all(
                                                                    10.0), // Marge autour de l'image lors du zoom
                                                            minScale:
                                                                0.5, // Échelle minimale du zoom
                                                            maxScale:
                                                                5.0, // Échelle maximale du zoom
                                                            child: Image.asset(
                                                              'images/walesa2.jpg',
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  style: ButtonStyle(
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(0),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppText(
                                                        text:
                                                            'Programme cultes',
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .canvasColor,
                                                          borderRadius:
                                                              borderRadius,
                                                        ),
                                                        child: Icon(
                                                          Icons
                                                              .av_timer_outlined,
                                                          color: Theme.of(
                                                                  context)
                                                              .unselectedWidgetColor,
                                                          size: 20,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          sizedbox,
                                          sizedbox,
                                          Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).focusColor,
                                              borderRadius: borderRadius,
                                            ),
                                            child: Column(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    concepteurs();
                                                  },
                                                  style: ButtonStyle(
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(0),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppText(
                                                        text: 'Développeur',
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .canvasColor,
                                                          borderRadius:
                                                              borderRadius,
                                                        ),
                                                        child: Icon(
                                                          Icons.person,
                                                          color: Theme.of(
                                                                  context)
                                                              .unselectedWidgetColor,
                                                          size: 20,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Transform.rotate(
                    angle: 180 * 3.1415927 / 90, // Angle de rotation en radians
                    child: const Icon(
                      Icons.settings,
                      size: 35.0,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
              child: Column(
                children: [
                  Hero(
                    tag: 'searchSreen',
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(videoItems),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(left: 8),
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).focusColor,
                          borderRadius: borderRadius,
                          border: Border.all(
                              color: Theme.of(context).dividerColor, width: 2),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Theme.of(context).cardColor,
                              ),
                              sizedbox2,
                              AppText(
                                text: 'Recherche...',
                                color: Theme.of(context).cardColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Expanded(
                    child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).focusColor,
                                  ),
                                ),
                              ),
                              sizedbox,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                      radius: 30,
                                      backgroundColor:
                                          Theme.of(context).focusColor),
                                  sizedbox2,
                                  Container(
                                    width: 300.0,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).focusColor),
                                  )
                                ],
                              ),
                              Lign(
                                indent:
                                    MediaQuery.of(context).size.width * 0.15,
                                endIndent:
                                    MediaQuery.of(context).size.width * 0.15,
                              )
                            ],
                          );
                        }),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: videoItems.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).focusColor,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            videoItems[index].imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0.20 * MediaQuery.of(context).size.width,
                                  left: 0.4 * MediaQuery.of(context).size.width,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VideoPlayerPage(
                                            videoLink:
                                                videoItems[index].videoLink,
                                            videoTitre: videoItems[index].title,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.activColor),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: AppColors.activColor),
                                      child: const Icon(Icons.play_arrow,
                                          size: 40, color: AppColors.mainColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).focusColor,
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        videoItems[index].imageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                sizedbox2,
                                SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.77,
                                  child: Text(
                                    videoItems[index].title[0].toUpperCase() +
                                        videoItems[index]
                                            .title
                                            .substring(1)
                                            .toLowerCase(),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            Lign(
                              indent: MediaQuery.of(context).size.width * 0.15,
                              endIndent:
                                  MediaQuery.of(context).size.width * 0.15,
                            )
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  propos() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).focusColor,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          contentPadding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 30,
            right: 30,
          ),
          title: Center(
            child: AppTextLarge(
              text: "A propos de l'application",
              color: Theme.of(context).hintColor,
              size: 16,
            ),
          ),
          content: AppText(
            text:
                'Le pasteur Kabundi Walesa a appelé les chrétiens de son église, en particulier et la population congolaise en général, à soutenir spirituellement le chef de l’État Félix Antoine Tshisekedi Tshilombo pour la réussite de son mandat en cours',
            size: 14,
            color: Theme.of(context).hintColor,
          ),
        );
      },
    );
  }

  Future concepteurs() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).focusColor,
          insetPadding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          title: Column(
            children: [
              Center(
                child: AppTextLarge(
                  text: 'Contacts :',
                  size: 16,
                  color: Theme.of(context).hintColor,
                ),
              ),
              sizedbox,
              AppText(
                text: 'nganduflory9@gmail.com',
                color: Theme.of(context).hintColor,
              ),
              AppText(
                text: '+243 826 671 449',
                color: Theme.of(context).hintColor,
              ),
              // AppText(
              //   text: 'pacomecuma2.0@gmail.com',
              //   color: Theme.of(context).cardColor,
              // ),
              // AppText(
              //   text: '+243 972 876 858',
              //   color: Theme.of(context).cardColor,
              // ),
              // sizedbox,
              // AppText(
              //   text: 'justinakonwa0@gmail.com',
              //   color: Theme.of(context).cardColor,
              // ),
              // AppText(
              //   text: '+243 975 024 769',
              //   color: Theme.of(context).cardColor,
              // ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          contentPadding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 30,
            right: 30,
          ),
        );
      },
    );
  }

  void checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
          backgroundColor: Colors.transparent,
          content: Container(
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).focusColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 30,
                  color: Colors.red,
                ),
                sizedbox,
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: AppText(
                      text:
                          'Erreur de connexion au serveur, verifier votre connexion internet',
                      color: AppColors.bigTextColor,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          duration: const Duration(seconds: 3), // Durée d'affichage en secondes
        ),
      );
      // ignore: avoid_print
      print('Pas de connexion Internet.');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('Connecté à Internet via Wi-Fi.');
    } else if (connectivityResult == ConnectivityResult.mobile) {
      print('Connecté à Internet via données mobiles.');
    }
  }
}

class VideoItem {
  final String videoId;
  final String imageUrl;
  final String videoLink;
  final String title;
  final String uploadDate;

  VideoItem(
      {required this.videoId,
      required this.imageUrl,
      required this.videoLink,
      required this.title,
      required this.uploadDate});

  get author => null;
}
