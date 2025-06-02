import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rebooked_app/core/theme.dart';

class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isAsset;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.isAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: isAsset
          ? Image.asset(
              imageUrl,
              width: width,
              height: height,
              fit: fit ?? BoxFit.cover,
              cacheWidth: width?.toInt(),
              cacheHeight: height?.toInt(),
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) return child;
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
            )
          : Image.network(
              imageUrl,
              width: width,
              height: height,
              fit: fit ?? BoxFit.cover,
              cacheWidth: width?.toInt(),
              cacheHeight: height?.toInt(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.gray.withOpacity(0.1),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.gray.withOpacity(0.1),
                  child: Icon(
                    Icons.error_outline,
                    color: AppColors.primary,
                    size: 24,
                  ),
                );
              },
            ),
    );
  }
}
