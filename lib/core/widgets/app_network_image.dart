import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Carrega uma imagem real via rede (screenshots oficiais, thumbnails de
/// vídeo, etc.) com cache local — em vez de empacotar imagens geradas por IA
/// como conteúdo "oficial" no app.
///
/// Quando [url] é nula/vazia, ou o carregamento falha, mostra um placeholder
/// neutro (sem tentar simular a imagem real) para deixar claro que aquele
/// conteúdo real ainda não foi definido, em vez de mascarar com arte falsa.
class AppNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final IconData placeholderIcon;
  final double? width;
  final double? height;
  final Color? color;
  final BlendMode? colorBlendMode;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.placeholderIcon = Icons.image_rounded,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) {
      return _placeholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fadeInDuration: const Duration(milliseconds: 250),
      placeholder: (context, _) => _loading(),
      errorWidget: (context, _, _) => _placeholder(),
    );
  }

  Widget _loading() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceLight,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textMuted),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceLight,
      alignment: Alignment.center,
      child: Icon(placeholderIcon, color: AppColors.textMuted, size: 32),
    );
  }
}
