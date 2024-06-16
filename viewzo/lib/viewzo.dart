library viewzo;

import 'package:flutter/material.dart';
import 'package:viewzo/src/components/image_loader.dart';
import 'package:viewzo/utils/utils.dart';

class ViewZo extends StatelessWidget {
  const ViewZo({
    Key? key,
    required this.items,
    required this.isPage,
  }): super(key: key);

  final List<String> items;
  final bool isPage;

  @override
  Widget build(BuildContext context) {
    if (isPage) {
      return PageView.builder(
        itemCount: items.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final image = items[index];
          if (Utils.isUrlFormat(image)) {
            return ImageLoader(
              imageUrl: image,
              fit: BoxFit.fill,
              placeholder: 'packages/viewzo/assets/images/mosic.png',
              placeHolderFit: BoxFit.fill,
              errorView: Image.asset(
                'packages/viewzo/assets/images/mosic.png',
                fit: BoxFit.fill,
              ),
            );
          }
          return Image.asset(
            image,
            fit: BoxFit.fill,
          );
        },
      );
    }
    return ListView.builder(
      itemCount: items.length,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final image = items[index];
        if (Utils.isUrlFormat(image)) {
          return ImageLoader(
            imageUrl: image,
            fit: BoxFit.fill,
            placeholder: 'packages/viewzo/assets/images/mosic.png',
            placeHolderFit: BoxFit.fill,
            errorView: Image.asset(
              'packages/viewzo/assets/images/mosic.png',
              fit: BoxFit.fill,
            ),
          );
        }
        return Image.asset(
          image,
          fit: BoxFit.fill,
        );
      },
    );
  }
}
