import 'package:flutter/material.dart';

class RadioStationModel {
  final String id;
  final String name;
  final String genre;
  final String frequency;
  final String currentTrack;
  final String artist;
  final IconData icon;
  final List<Color> gradientColors;
  final List<String> playlist;

  /// URL de stream de áudio real (rádio de internet pública/legal) que toca
  /// de verdade dentro do app — não é a trilha licenciada do jogo (que não
  /// pode ser reproduzida), mas uma estação real com o gênero equivalente.
  final String streamUrl;

  /// Nome da estação de internet real por trás do stream, para dar crédito
  /// (ex.: "via Heart 80s").
  final String streamSourceName;

  const RadioStationModel({
    required this.id,
    required this.name,
    required this.genre,
    required this.frequency,
    required this.currentTrack,
    required this.artist,
    required this.icon,
    required this.gradientColors,
    required this.playlist,
    required this.streamUrl,
    required this.streamSourceName,
  });
}
