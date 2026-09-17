import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

/// Compartilha um texto simples (notícia, vídeo etc.) via share sheet nativo.
Future<void> shareText(String text) async {
  await SharePlus.instance.share(ShareParams(text: text));
}

/// Captura o widget marcado por [key] com um [RepaintBoundary] como PNG e
/// abre o share sheet nativo com essa imagem + [text]. Usado para os "cards
/// de hype" (ex: contagem regressiva) que o fã compartilha nas redes.
Future<void> shareWidgetAsImage(GlobalKey key, {required String text}) async {
  final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) return;

  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) return;

  final bytes = byteData.buffer.asUint8List();
  final file = XFile.fromData(bytes, name: 'gtavi_hype.png', mimeType: 'image/png');

  await SharePlus.instance.share(ShareParams(text: text, files: [file]));
}
