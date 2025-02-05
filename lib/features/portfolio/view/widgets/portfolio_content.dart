import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schedule_app/core/bloc/fetch_portfolio_photos/local_portfolio_photos_bloc.dart';
import 'package:schedule_app/core/widgets/alert_confirm_dialog.dart';
import 'package:schedule_app/features/portfolio/bloc/actions_portfolio_photos_bloc.dart';
import 'package:schedule_app/features/portfolio/view/widgets/carousel_widget.dart';
import 'package:schedule_app/core/utils/snackbar_utils.dart';

class PortfolioContent extends StatefulWidget {
  const PortfolioContent({super.key, required this.imageUrlList});

  final List<String> imageUrlList;

  @override
  State<PortfolioContent> createState() => _PortfolioContentState();
}

class _PortfolioContentState extends State<PortfolioContent> {
  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<ExpandableFabState>();
    bool autoPlay = true;

    void toggleFloatingButton() {
      final state = _key.currentState;
      if (state != null) {
        debugPrint('isOpen:${state.isOpen}');
        state.toggle();
      }
    }

    void pickImageFromCam(void Function(File imageFile) addImage) async {
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

    void pickImageFromGal(void Function(File imageFile) addImage) async {
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
      print(pickedImage.path);
      addImage(File(pickedImage.path));
    }

    void renew() {
      context.read<LocalPortfolioPhotosBloc>().add(FetchPortfolioPhotosData());
    }

    void showConfirmDialog(void Function() deleteImage) async {
      setState(() {
        autoPlay = false;
      });
      await showDialog(
          context: context,
          builder: (ctx) => AlertConfirmDialog(
              title: 'Удалить фото?',
              content: 'Фото будет удалено навсегда.',
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
      // print(imgList);
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(0.5))),
                              height: MediaQuery.of(context).size.height,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null, // Прогресс загрузки, если известен размер.
                                ),
                              ),
                            );
                          },
                        ))),
              ))
          .toList();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Портфолио'),
          actions: [
            IconButton(onPressed: renew, icon: const Icon(Icons.autorenew))
          ],
        ),
        body: widget.imageUrlList.isNotEmpty
            ? SingleChildScrollView(
                child: CarouselWidget(
                  imageSliders:
                      getWidgetImageList(widget.imageUrlList, (imageUrl) {
                    context
                        .read<ActionsPortfolioPhotosBloc>()
                        .add(DeletePortfolioPhotoEvent(imageUrl: imageUrl));
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
                pickImageFromGal((File imageFile) {
                  context
                      .read<ActionsPortfolioPhotosBloc>()
                      .add(CreatePortfolioPhotoEvent(imageFile: imageFile));
                });
              },
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.camera),
              onPressed: () {
                pickImageFromCam((File imageFile) {
                  context
                      .read<ActionsPortfolioPhotosBloc>()
                      .add(CreatePortfolioPhotoEvent(imageFile: imageFile));
                });
              },
            ),
          ],
        ));
  }
}
