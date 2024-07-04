library viewzo;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:viewzo/src/image_libery.dart';
import 'package:viewzo/src/model/page_view_model.dart';

/// A widget that displays a list or a page view of images.
///
/// The [ViewZo] widget can display images either in a scrollable list or as
/// pages, depending on the [isPage] flag. It supports various customization
/// options for the scroll bar and image loading.
class ViewZo extends StatefulWidget {
  /// A list of image URLs or asset paths to display.
  final List<String> items;

  /// Whether to display the images as pages. If false, displays them in a list.
  final bool isPage;

  /// How to inscribe the image into the space allocated during layout.
  final BoxFit fit;

  /// The width of the images.
  final double? width;

  /// The height of the images.
  final double? height;

  /// A callback function that reports the current scroll offset.
  final void Function(double)? scrollOffsetCallback;

  /// A callback function that reports the current page index.
  final void Function(int)? pageCallback;

  /// The width of the scroll bar thumb.
  final double? scrollBarThumbWidth;

  /// The color of the scroll bar thumb.
  final Color? scrollBarThumbColor;

  /// Whether the scroll bar thumb is visible.
  final bool? scrollBarThumbVisibility;

  /// Whether the scroll bar track is visible.
  final bool? scrollBarTrackVisibility;

  /// The color of the scroll bar track.
  final Color? scrollBarTrackColor;

  /// The radius of the scroll bar thumb.
  final Radius? scrollBarThumbRadius;

  /// The radius of the scroll bar track.
  final Radius? scrollBarTrackRadius;

  /// Headers to include with the image requests.
  final Map<String, String>? headers;

  /// Creates a [ViewZo] widget.
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

class _ViewZoState extends State<ViewZo> with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  late PageController _pageController;
  final Map<int, int> _pageCountMap = {};
  List<PageViewItem> _pageViewItems = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageController = PageController();

    _scrollController.addListener(_scrollListener);
    _pageController.addListener(_pageListener);
    _initializePageViewItems();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  /// Page count calculation.
  void _initializePageViewItems() {
    _pageViewItems = [];
    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      if (item.endsWith('.pdf')) {
        final pageCount = _pageCountMap[i] ?? 1;
        for (int j = 0; j < pageCount; j++) {
          _pageViewItems.add(PageViewItem(url: item, pageIndex: j));
        }
      } else {
        _pageViewItems.add(PageViewItem(url: item));
      }
    }
  }

  /// Listener for the scroll controller that reports the current scroll position.
  void _scrollListener() {
    if (widget.scrollOffsetCallback != null) {
      widget.scrollOffsetCallback!(_scrollController.position.pixels);
    }
  }

  /// Listener for the page controller that reports the current page index.
  void _pageListener() {
    if (widget.pageCallback != null) {
      widget.pageCallback!(_pageController.page!.round());
    }
  }

  /// Listener for the page count.
  void _onPageCount(int index, int count, String url) {
    setState(() {
      log('index :: $index count:: $count');

      for (int i = 0; i < widget.items.length; i++) {
        if (widget.items[i] == url) {
          _pageCountMap[i] = count;
        }
      }
      _initializePageViewItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.isPage) {
      return InteractiveViewer(
        panEnabled: true,
        scaleEnabled: true,
        minScale: 0.5,
        maxScale: 4.0,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _pageViewItems.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            final item = _pageViewItems[index];
            return ImageLoader(
              url: item.url,
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
              isPage: widget.isPage,
              pageController: _pageController,
              onPageCount: (count, url) => _onPageCount(index, count, url),
              pageIndex: item.pageIndex,
            );
          },
        ),
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
      child: InteractiveViewer(
        panEnabled: true,
        scaleEnabled: true,
        minScale: 0.5,
        maxScale: 4.0,
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.zero,
          itemCount: widget.items.length,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final image = widget.items[index];
            return ImageLoader(
              url: image,
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
              isPage: widget.isPage,
              pageController: _pageController,
              onPageCount: (count, url) => _onPageCount(index, count, url),
            );
          },
        ),
      ),
    );
  }
}
