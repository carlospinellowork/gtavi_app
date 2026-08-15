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
  });
}
