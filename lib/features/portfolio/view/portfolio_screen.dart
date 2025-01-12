import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schedule_app/core/bloc/fetch_portfolio_photos/fetch_portfolio_photos_bloc.dart';
import 'package:schedule_app/features/portfolio/view/widgets/carousel_widget.dart';
import 'package:schedule_app/features/portfolio/bloc/actions_portfolio_photos_bloc.dart';
import 'package:schedule_app/core/widgets/card_circular_progress_indicator.dart';

import 'package:schedule_app/core/widgets/alert_confirm_dialog.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final _key = GlobalKey<ExpandableFabState>();
  bool autoPlay = true;

  void toggleFloatingButton() {
    final state = _key.currentState;
    if (state != null) {
      debugPrint('isOpen:${state.isOpen}');
      state.toggle();
    }
  }

  void _pickImageFromCam(void Function(File imageFile) addImage) async {
    toggleFloatingButton();
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (pickedImage == null) {
      return;
    }
    addImage(File(pickedImage.path));
  }

  void _pickImageFromGal(void Function(File imageFile) addImage) async {
    toggleFloatingButton();

    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (pickedImage == null) {
      return;
    }
    addImage(File(pickedImage.path));
  }

  @override
  Widget build(BuildContext context) {
    void renew() {
      context.read<FetchPortfolioPhotosBloc>().add(FetchPortfolioPhotosData());
    }

    void showConfirmDialog(void Function() deleteImage) async {
      setState(() {
        autoPlay = false;
      });
      await showDialog(
          context: context,
          builder: (ctx) => AlertConfirmDialog(
              title: 'Удалить фото?',
              content: 'Фото будет удалена навсегда.',
              onConfirm: () {
                deleteImage();
              }));

      if (mounted) {
        setState(() {
          autoPlay = true;
        });
      }
    }

    List<Widget> getWidgetImageList(
        List<String> imgList, void Function(String imageUrl) deleteImage) {
      return imgList
          .map((item) => ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Center(
                    child: InkWell(
                  onLongPress: () {
                    showConfirmDialog(() {
                      deleteImage(item);
                    });
                  },
                  child: Image.network(
                    item,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Когда изображение загружено, оно отображается.
                      }
                      return Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(0.5))),
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null, // Прогресс загрузки, если известен размер.
                          ),
                        ),
                      );
                    },
                  ),
                )),
              ))
          .toList();
    }

    return BlocBuilder<ActionsPortfolioPhotosBloc, ActionsPortfolioPhotosState>(
      builder: (context, state) {
        return BlocBuilder<FetchPortfolioPhotosBloc, FetchPortfolioPhotosState>(
          builder: (context, portfolioState) {
            if (portfolioState is FetchPortfolioPhotosLoadingState) {
              return const Center(
                child: CardCircularProgressIndicator(),
              );
            }
            if (portfolioState is FetchPortfolioPhotosLoadedState) {
              List<String> imageUrlList = portfolioState.downloadUrls;

              return Scaffold(
                  appBar: AppBar(
                    title: const Text('Портфолио'),
                    actions: [
                      IconButton(
                          onPressed: renew, icon: const Icon(Icons.autorenew))
                    ],
                  ),
                  body: imageUrlList.isNotEmpty
                      ? SingleChildScrollView(
                          child: CarouselWidget(
                            imageSliders:
                                getWidgetImageList(imageUrlList, (imageUrl) {
                              context.read<ActionsPortfolioPhotosBloc>().add(
                                  DeletePortfolioPhotoEvent(
                                      imageUrl: imageUrl));
                            }),
                            autoPlay: autoPlay,
                          ),
                        )
                      : const Center(child: Text('Пока ничего.')),
                  floatingActionButtonLocation: ExpandableFab.location,
                  floatingActionButton: ExpandableFab(
                    key: _key,
                    type: ExpandableFabType.up,
                    childrenAnimation: ExpandableFabAnimation.none,
                    distance: 70,
                    overlayStyle: ExpandableFabOverlayStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    openButtonBuilder: RotateFloatingActionButtonBuilder(
                      child: const Icon(Icons.add),
                    ),
                    children: [
                      FloatingActionButton.small(
                        heroTag: null,
                        child: const Icon(Icons.photo_sharp),
                        onPressed: () {
                          _pickImageFromGal((File imageFile) {
                            context.read<ActionsPortfolioPhotosBloc>().add(
                                CreatePortfolioPhotoEvent(
                                    imageFile: imageFile));
                          });
                        },
                      ),
                      FloatingActionButton.small(
                        heroTag: null,
                        child: const Icon(Icons.camera),
                        onPressed: () {
                          _pickImageFromCam((File imageFile) {
                            context.read<ActionsPortfolioPhotosBloc>().add(
                                CreatePortfolioPhotoEvent(
                                    imageFile: imageFile));
                          });
                        },
                      ),
                    ],
                  ));
            }
            return const Center(
              child: CardCircularProgressIndicator(),
            );
          },
        );
      },
    );
  }
}
