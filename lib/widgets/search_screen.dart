// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:walesa/play.dart';
import 'package:walesa/widgets/colors.dart';
import 'package:walesa/widgets/lign.dart';
import '../page/movie_page.dart';
import 'app_text.dart';

class SearchPage extends StatefulWidget {
  final List<VideoItem> videoItems;

  const SearchPage(this.videoItems, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  List<VideoItem> searchResults = [];
  bool issearch = true;
  bool isssearch = false;

  void searchVideos(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        searchResults.clear(); // Efface les résultats de recherche précédents
      } else {
        searchResults = widget.videoItems
            .where((video) =>
                video.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      issearch = false;
    });
  }

  List<VideoItem> getVideosByLetter(String letter) {
    return widget.videoItems
        .where((video) => video.title.toLowerCase().contains(letter))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    bool hasSearchResults = searchResults.isNotEmpty;
    List<VideoItem> filteredVideos =
        getVideosByLetter(searchQuery.toLowerCase());
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Theme.of(context).hintColor,
            elevation: 0.0,
            backgroundColor: Theme.of(context).backgroundColor,
            title: Container(
              padding: const EdgeInsets.only(left: 8),
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).focusColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).dividerColor, width: 2),
              ),
              child: TextField(
                onChanged: searchVideos,
                decoration: const InputDecoration(
                  hintText: 'Recherche...',
                  hintStyle: TextStyle(),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              issearch
                  ? Container(
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.cloud_off_rounded,
                        size: 150,
                      ),
                    )
                  : (hasSearchResults)
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final video = searchResults[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            width: MediaQuery.of(context).size.width *0.35,
                                            child: Container(
                                              margin: const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                image: DecorationImage(
                                                  image:
                                                      NetworkImage(video.imageUrl),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0.08 *
                                                MediaQuery.of(context).size.width,
                                            right: 0.16 *
                                                MediaQuery.of(context).size.width,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        VideoPlayerPage(
                                                      videoLink: videoItems[index]
                                                          .videoLink,
                                                      videoTitre:
                                                          videoItems[index].title,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    shape: BoxShape.circle,
                                                    color: Colors.black26),
                                                child: const Icon(
                                                  Icons.play_arrow,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 80.0,
                                        width:
                                            MediaQuery.of(context).size.width * 0.6,
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
                                                video.title,
                                                style: const TextStyle(),
                                                maxLines: 2,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              child: AppText(
                                                text: video.uploadDate,
                                                color: AppColors.mainTextColor,
                                                size: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
                            },
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Aucun résultat trouvé',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).hintColor),
                          ),
                        ),
            ],
          ),
        );

  }}