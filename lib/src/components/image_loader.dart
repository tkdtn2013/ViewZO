import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

/// A widget that loads and displays an image from a URL, with support for placeholder and error views,
/// and handles both image and PDF content types.
///
/// [ImageLoader] can display a single image or multiple pages if the content is a PDF.
/// It also provides retry functionality in case of loading errors.
class ImageLoader extends StatefulWidget {
  /// The URL of the image or PDF to load.
  final String url;

  /// The path to the placeholder image to display while loading.
  final String placeholder;

  /// The widget to display in case of an error.
  final Widget errorView;

  /// How to inscribe the image into the space allocated during loading.
  final BoxFit fit;

  /// How to inscribe the placeholder image into the space allocated during loading.
  final BoxFit placeHolderFit;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// The HTTP headers to include in the request.
  final Map<String, String>? headers;

  /// Indicates if the content is a multi-page document (e.g., PDF).
  final bool isPage;

  /// The controller to manage page view.
  final PageController pageController;

  /// Callback to notify the parent widget of the number of pages.
  final Function(int) onPageCount;

  /// The index of the page to display if the content is a multi-page document.
  final int pageIndex;

  /// Creates an [ImageLoader] widget.
  const ImageLoader({
    required this.url,
    required this.placeholder,
    required this.errorView,
    required this.fit,
    required this.placeHolderFit,
    this.width,
    this.height,
    this.headers,
    required this.isPage,
    required this.pageController,
    required this.onPageCount,
    this.pageIndex = 0,
  });

  @override
  State<ImageLoader> createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late Future<List<Uint8List>> _data;
  String _errorMessage = '';
  late AnimationController _animationController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _data = _fetchData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Fetches the data from the given URL.
  Future<List<Uint8List>> _fetchData() async {
    try {
      final uri = Uri.parse(widget.url);

      final response = await _httpGet(uri, widget.headers);

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final contentType = response.headers['content-type'];

        if (contentType != null && contentType.contains('application/pdf')) {
          return _processPdf(bytes);
        } else if (contentType != null && contentType.startsWith('image/')) {
          return [bytes];
        } else {
          _errorMessage = 'Unsupported content type: $contentType';
          log(_errorMessage);
          throw Exception(_errorMessage);
        }
      } else {
        _errorMessage = 'Failed to load data: HTTP ${response.statusCode}';
        log(_errorMessage);
        throw Exception(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Failed to load data: ${e.toString()}';
      log(_errorMessage);
      throw Exception(_errorMessage);
    }
  }

  /// Makes an HTTP GET request to the given URI with optional headers.
  Future<http.Response> _httpGet(Uri uri, Map<String, String>? headers) async {
    if (kIsWeb) {
      return http.get(uri, headers: headers);
    } else {
      final httpClient = io.HttpClient();
      final request = await httpClient.getUrl(uri);
      headers?.forEach((key, value) {
        request.headers.set(key, value);
      });
      final response = await request.close();
      final responseBytes = await consolidateHttpClientResponseBytes(response);

      final responseHeaders = <String, String>{};
      response.headers.forEach((name, values) {
        responseHeaders[name] = values.join(', ');
      });

      return http.Response.bytes(responseBytes, response.statusCode,
          headers: responseHeaders);
    }
  }

  /// Processes a PDF document and returns a list of byte arrays representing the pages as images.
  Future<List<Uint8List>> _processPdf(Uint8List bytes) async {
    final document = await PdfDocument.openData(bytes);
    final pages = <Uint8List>[];

    for (var i = 1; i <= document.pagesCount; i++) {
      final page = await document.getPage(i);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
        format: PdfPageImageFormat.png,
      );
      pages.add(pageImage!.bytes);
    }

    widget.onPageCount(pages.length);
    return pages;
  }

  /// Retries loading the data by restarting the animation and fetching the data again.
  void _retryLoadData() {
    _animationController.forward(from: 0.0).then((_) {
      setState(() {
        _data = _fetchData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Uint8List>>(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Image.asset(
            widget.placeholder,
            fit: widget.placeHolderFit,
          );
        } else if (snapshot.hasError) {
          return Stack(
            children: [
              widget.errorView,
              Positioned.fill(
                child: Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 62),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animationController.value *
                            2.0 *
                            3.1415927, // 360-degree rotation
                        child: IconButton(
                          onPressed: _retryLoadData,
                          icon: Image.asset(
                            'packages/viewzo/assets/images/refreshIcon.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          final data = snapshot.data!;
          if (widget.isPage) {
            return Image.memory(
              data[widget.pageIndex],
              fit: widget.fit,
              width: widget.width,
              height: widget.height,
            );
          }
          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Image.memory(
                data[index],
                fit: widget.fit,
                width: widget.width,
                height: widget.height,
              );
            },
          );
        }
      },
    );
  }
}

/// Consolidates the bytes from an [io.HttpClientResponse] into a [Uint8List].
Future<Uint8List> consolidateHttpClientResponseBytes(
    io.HttpClientResponse response) async {
  final completer = Completer<Uint8List>();
  final contents = <int>[];
  response.listen(
    (List<int> data) => contents.addAll(data),
    onDone: () => completer.complete(Uint8List.fromList(contents)),
    onError: completer.completeError,
    cancelOnError: true,
  );
  return completer.future;
}
