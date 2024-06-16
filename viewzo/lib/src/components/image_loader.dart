import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ImageLoader extends StatefulWidget {
  final String imageUrl;
  final String placeholder;
  final Widget errorView;
  final BoxFit fit;
  final BoxFit placeHolderFit;

  ImageLoader({
    required this.imageUrl,
    required this.placeholder,
    required this.errorView,
    required this.fit,
    required this.placeHolderFit,
  });

  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late Future<Uint8List> _imageData;
  String _errorMessage = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _imageData = _fetchImage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<Uint8List> _fetchImage() async {
    try {
      final response = await http.get(Uri.parse(widget.imageUrl));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        _errorMessage = 'Failed to load image: HTTP ${response.statusCode}';
        print(_errorMessage);
        throw Exception(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Failed to load image: ${e.toString()}';
      print(_errorMessage);
      throw Exception(_errorMessage);
    }
  }

  void _retryLoadImage() {
    _animationController.forward(from: 0.0).then((_) {
      setState(() {
        _imageData = _fetchImage();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<Uint8List>(
      future: _imageData,
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
                    margin: EdgeInsets.only(top: 62),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animationController.value * 2.0 * 3.1415927, // 360도 회전
                          child: IconButton(
                            onPressed: _retryLoadImage,
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
          return Image.memory(
            snapshot.data!,
            fit: widget.fit,
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}