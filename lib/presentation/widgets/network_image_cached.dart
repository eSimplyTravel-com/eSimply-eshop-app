import "dart:io";

import "package:cached_network_image/cached_network_image.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/widgets/_svg_local_file_io.dart"
    if (dart.library.js_interop) "package:esim_open_source/presentation/widgets/_svg_local_file_web.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:path/path.dart" as path;

enum ImageSource { network, local }

class ImageDimensions {
  const ImageDimensions({
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final double? width;
  final double? height;
  final BoxFit? fit;
}

class ImageWidgets {
  const ImageWidgets({
    this.placeholder,
    this.errorWidget,
  });

  final Widget? placeholder;
  final Widget? errorWidget;
}

class ImageAnimations {
  const ImageAnimations({
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.placeholderFadeInDuration = const Duration(milliseconds: 300),
    this.errorFadeInDuration = const Duration(milliseconds: 300),
  });

  final Duration? fadeInDuration;
  final Duration placeholderFadeInDuration;
  final Duration errorFadeInDuration;
}

class CachedImage extends StatelessWidget {
  const CachedImage({
    required this.imagePath,
    required this.source,
    super.key,
    ImageDimensions? dimensions,
    ImageWidgets? widgets,
    ImageAnimations? animations,
    this.svgColor,
    this.repeat = true,
  })  : _dimensions = dimensions ?? const ImageDimensions(),
        _widgets = widgets ?? const ImageWidgets(),
        _animations = animations ?? const ImageAnimations();

  final String imagePath;
  final ImageSource source;
  final ImageDimensions _dimensions;
  final ImageWidgets _widgets;
  final ImageAnimations _animations;
  final Color? svgColor;
  final bool? repeat;

  double? get width => _dimensions.width;
  double? get height => _dimensions.height;
  BoxFit? get fit => _dimensions.fit;
  Widget? get placeholder => _widgets.placeholder;
  Widget? get errorWidget => _widgets.errorWidget;
  Duration? get fadeInDuration => _animations.fadeInDuration;
  Duration get placeholderFadeInDuration => _animations.placeholderFadeInDuration;
  Duration get errorFadeInDuration => _animations.errorFadeInDuration;

  static CachedImage local({
    required String imagePath,
    ImageDimensions? dimensions,
    ImageWidgets? widgets,
    ImageAnimations? animations,
    Color? svgColor,
    bool? repeat = true,
  }) {
    return CachedImage(
      imagePath: imagePath,
      source: ImageSource.local,
      dimensions: dimensions,
      widgets: widgets,
      animations: animations,
      svgColor: svgColor,
      repeat: repeat,
    );
  }

  static CachedImage network({
    required String imagePath,
    ImageDimensions? dimensions,
    ImageWidgets? widgets,
    ImageAnimations? animations,
    Color? svgColor,
    bool? repeat = true,
  }) {
    return CachedImage(
      imagePath: imagePath,
      source: ImageSource.network,
      dimensions: dimensions,
      widgets: widgets,
      animations: animations,
      svgColor: svgColor,
      repeat: repeat,
    );
  }

  bool get _isSvg => path.extension(imagePath).toLowerCase() == ".svg";

  bool get _isGif => path.extension(imagePath).toLowerCase() == ".gif";

  @override
  Widget build(BuildContext context) {
    if (_isSvg) {
      return _buildSvgImage();
    }
    return source == ImageSource.network
        ? _buildNetworkImage()
        : _buildLocalImage();
  }

  Widget _buildSvgImage() {
    String svgImage = "SVG Image";
    if (source == ImageSource.network) {
      return SvgPicture.network(
        imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        colorFilter: svgColor != null
            ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (BuildContext context) => _buildPlaceholder(),
        semanticsLabel: svgImage,
      );
    } else if (imagePath.startsWith("assets/")) {
      return SvgPicture.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        colorFilter: svgColor != null
            ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (BuildContext context) => _buildPlaceholder(),
        semanticsLabel: svgImage,
      );
    } else {
      return buildLocalFileSvg(
        imagePath: imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        colorFilter: svgColor != null
            ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (BuildContext context) => _buildPlaceholder(),
        semanticsLabel: svgImage,
      );
    }
  }

  Widget _buildNetworkImage() {
    if (_isGif) {
      return _buildGifImage();
    }

    return CachedNetworkImage(
      imageUrl: imagePath,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
      placeholder: (BuildContext context, String url) => _buildPlaceholder(),
      errorWidget: (BuildContext context, String url, Object error) =>
          _buildErrorWidget(),
      imageBuilder:
          (BuildContext context, ImageProvider<Object> imageProvider) =>
              Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildLocalImage() {
    // Check if the path starts with 'assets/' - indicating it's an asset, not a true local file
    if (imagePath.startsWith("assets/")) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: (
          BuildContext context,
          Widget child,
          int? frame,
          bool wasSynchronouslyLoaded,
        ) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: fadeInDuration ?? const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) =>
                _buildErrorWidget(),
      );
    }

    // Handle true local file
    final File file = File(imagePath);
    if (!file.existsSync()) {
      return _buildErrorWidget();
    }

    if (_isGif) {
      return _buildLocalGifImage(file);
    }

    return Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (
        BuildContext context,
        Widget child,
        int? frame,
        bool wasSynchronouslyLoaded,
      ) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: fadeInDuration ?? const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) =>
              _buildErrorWidget(),
    );
  }

  Widget _buildGifImage() {
    return CachedNetworkImage(
      imageUrl: imagePath,
      width: width,
      height: height,
      fit: fit,
      placeholder: (BuildContext context, String url) => _buildPlaceholder(),
      errorWidget: (BuildContext context, String url, Object error) =>
          _buildErrorWidget(),
      imageBuilder:
          (BuildContext context, ImageProvider<Object> imageProvider) => Image(
        image: imageProvider,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: (
          BuildContext context,
          Widget child,
          int? frame,
          bool wasSynchronouslyLoaded,
        ) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: fadeInDuration ?? const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
        repeat: repeat! ? ImageRepeat.repeat : ImageRepeat.noRepeat,
        gaplessPlayback: true,
      ),
    );
  }

  Widget _buildLocalGifImage(File file) {
    return Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (
        BuildContext context,
        Widget child,
        int? frame,
        bool wasSynchronouslyLoaded,
      ) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: fadeInDuration ?? const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) =>
              _buildErrorWidget(),
      gaplessPlayback: true,
      repeat: repeat! ? ImageRepeat.repeat : ImageRepeat.noRepeat,
    );
  }

  Widget _buildPlaceholder() {
    if (placeholder != null) {
      return placeholder!;
    }

    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (errorWidget != null) {
      return errorWidget!;
    }

    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: Colors.grey[400],
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            "Image not available",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool?>("repeat", repeat))
      ..add(StringProperty("imagePath", imagePath))
      ..add(EnumProperty<ImageSource>("source", source))
      ..add(DoubleProperty("width", _dimensions.width))
      ..add(DoubleProperty("height", _dimensions.height))
      ..add(EnumProperty<BoxFit?>("fit", _dimensions.fit))
      ..add(DiagnosticsProperty<Duration?>("fadeInDuration", _animations.fadeInDuration))
      ..add(
        DiagnosticsProperty<Duration>(
          "placeholderFadeInDuration",
          _animations.placeholderFadeInDuration,
        ),
      )
      ..add(
        DiagnosticsProperty<Duration>(
          "errorFadeInDuration",
          _animations.errorFadeInDuration,
        ),
      )
      ..add(ColorProperty("svgColor", svgColor));
  }
}

@AppPreview(name: "Cached Image")
Widget cachedImagePreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: CachedImage.network(
        imagePath: "https://picsum.photos/200",
        dimensions: const ImageDimensions(width: 200, height: 200),
      ),
    ),
  );
}
