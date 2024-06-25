library viewzo;

import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:viewzo/src/components/image_loader.dart';
import 'package:viewzo/utils/utils.dart';

class ViewZo extends StatefulWidget {
  final List<String> items;
  final bool isPage;
  final BoxFit fit;
  final double? width;
  final double? height;
  final void Function(double)? scrollOffsetCallback;
  final void Function(int)? pageCallback;
  final double? scrollBarThumbWidth;
  final Color? scrollBarThumbColor;
  final bool? scrollBarThumbVisibility;
  final bool? scrollBarTrackVisibility;
  final Color? scrollBarTrackColor;
  final Radius? scrollBarThumbRadius;
  final Radius? scrollBarTrackRadius;
  final Map<String, String>? headers;

  const ViewZo({
    super.key,
    required this.items,
    required this.isPage,
    required this.fit,
    this.width,
    this.height,
    this.scrollOffsetCallback,
    this.pageCallback,
    this.scrollBarThumbWidth,
    this.scrollBarThumbColor,
    this.scrollBarThumbVisibility,
    this.scrollBarTrackVisibility,
    this.scrollBarTrackColor,
    this.scrollBarThumbRadius,
    this.scrollBarTrackRadius,
    this.headers,
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
    log("Scroll Position: ${_scrollController.position.pixels}");
    if (widget.scrollOffsetCallback != null) {
      widget.scrollOffsetCallback!(_scrollController.position.pixels);
    }
  }

  void _pageListener() {
    log("Page Position: ${_pageController.page!.round()}");
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
              headers: widget.headers,
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
      thickness: widget.scrollBarThumbWidth,
      thumbColor: widget.scrollBarThumbColor ?? Colors.transparent,
      thumbVisibility: widget.scrollBarThumbVisibility,
      trackVisibility: widget.scrollBarTrackVisibility,
      trackColor: widget.scrollBarTrackColor,
      radius: widget.scrollBarThumbRadius,
      trackRadius: widget.scrollBarTrackRadius,
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
              headers: widget.headers,
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