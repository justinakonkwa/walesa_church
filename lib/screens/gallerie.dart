// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../widgets/app_text_large.dart';
import '../widgets/colors.dart';

class GaleriePage extends StatelessWidget {
  final List<String> images = [
    'images/walesa.jpg',
    'images/walesa1.png',
    'images/walesa3.jpg',
    // Ajoutez ici d'autres URL d'images que vous souhaitez afficher
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.075),
              alignment: Alignment.centerLeft,
              child: AppTextLarge(
                text: 'Gallerie',
                size: 25,
                color: Theme.of(context).disabledColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: AppTextLarge(
                    text: 'Walesa',
                    size: 18,
                    color: AppColors.activColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: const Icon(Icons.arrow_back),
                  ),
                )
              ],
            ),
            Expanded(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 4, // Définissez le nombre de colonnes ici
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Hero(
                    tag: "images",
                    child: GestureDetector(
                      onTap: () {
                        // Gérer le clic sur une image ici (par exemple, afficher en grand)
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: InteractiveViewer(
                                panEnabled:
                                    false, // Désactive le déplacement par glissement
                                boundaryMargin: const EdgeInsets.all(
                                    10.0), // Marge autour de l'image lors du zoom
                                minScale: 0.5, // Échelle minimale du zoom
                                maxScale: 5.0, // Échelle maximale du zoom
                                child: Image.asset(
                                  images[index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (int index) => const StaggeredTile.fit(2),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ImageDetailPage extends StatelessWidget {
//   final String imageUrl;

//   ImageDetailPage({required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       body: SizedBox(
        
//         child: Center(
//           child: Image.asset(
//             imageUrl,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }
