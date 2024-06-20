library viewzo;

import 'package:flutter/material.dart';
import 'package:viewzo/src/components/image_loader.dart';
import 'package:viewzo/utils/utils.dart';

class ViewZo extends StatefulWidget {
  final List<String> items;
  final bool isPage;
  final BoxFit fit;
  final double? width;
  final double? height;
  void Function(double)? scrollOffsetCallback;
  void Function(int)? pageCallback;
  double? scrollBarthickness = 20;
  Color? scrollThumbColor = Colors.black.withOpacity(0.5);
  bool? scrollBarThumbVisibility = false;
  bool? scrollBarTrackVisibility = false;
  Color? scrollBarTrackColor = Colors.transparent;

  ViewZo({
    super.key,
    required this.items,
    required this.isPage,
    required this.fit,
    this.width,
    this.height,
    this.scrollOffsetCallback,
    this.pageCallback,
    this.scrollBarthickness,
    this.scrollThumbColor,
    this.scrollBarThumbVisibility,
    this.scrollBarTrackVisibility,
    this.scrollBarTrackColor,
  });

  @override
  State<ViewZo> createState() => _ViewZoState();
}

class _ViewZoState extends State<ViewZo> {
  late ScrollController _scrollController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageController = PageController();

    _scrollController.addListener(_scrollListener);
    _pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }


  void _scrollListener() {
    print("Scroll Position: ${_scrollController.position.pixels}");
    if (widget.scrollOffsetCallback != null) {
      widget.scrollOffsetCallback!(_scrollController.position.pixels);
    }
  }

  void _pageListener() {
    print("Page Position: ${_pageController.page!.round()}");
    if (widget.pageCallback != null) {
      widget.pageCallback!(_pageController.page!.round());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPage) {
      return PageView.builder(
        controller: _pageController,
        itemCount: widget.items.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final image = widget.items[index];
          if (Utils.isUrlFormat(image)) {
            return ImageLoader(
              imageUrl: image,
              fit: widget.fit,
              width: widget.width,
              height: widget.height,
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
    return RawScrollbar(
      thickness: widget.scrollBarthickness,
      thumbColor: widget.scrollThumbColor,
      thumbVisibility: widget.scrollBarThumbVisibility,
      trackVisibility: widget.scrollBarTrackVisibility,
      trackColor: widget.scrollBarTrackColor,
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: widget.items.length,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final image = widget.items[index];
          if (Utils.isUrlFormat(image)) {
            return ImageLoader(
              imageUrl: image,
              fit: widget.fit,
              width: widget.width,
              height: widget.height,
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
            fit: widget.fit,
            width: widget.width,
            height: widget.height,
          );
        },
      ),
    );
  }
}