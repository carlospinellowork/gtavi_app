import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../domain/radio_station_model.dart';

abstract class RadioRepository {
  Future<List<RadioStationModel>> getStations();
}

class MockRadioRepository implements RadioRepository {
  final List<RadioStationModel> _stations = const [
    RadioStationModel(
      id: 'st_flash',
      name: 'Flash FM 98.3',
      genre: 'Pop 80s & Vice Hits',
      frequency: '98.3 FM',
      currentTrack: 'Out of Touch',
      artist: 'Hall & Oates',
      icon: Icons.radio_rounded,
      gradientColors: [AppColors.primary, AppColors.secondary],
      playlist: [
        'Out of Touch - Hall & Oates',
        'Billie Jean - Michael Jackson',
        'Self Control - Laura Branigan',
        'Dance Hall Days - Wang Chung',
      ],
      streamUrl: 'https://media-ssl.musicradio.com/Heart80sMP3',
      streamSourceName: 'Heart 80s',
    ),
    RadioStationModel(
      id: 'st_wave',
      name: 'Wave 103',
      genre: 'Synthwave & New Wave',
      frequency: '103.1 FM',
      currentTrack: 'Love Is a Battlefield',
      artist: 'Pat Benatar',
      icon: Icons.graphic_eq_rounded,
      gradientColors: [AppColors.secondary, Colors.purpleAccent],
      playlist: [
        'Love Is a Battlefield - Pat Benatar',
        'Blue Monday - New Order',
        'Obsession - Animotion',
        'Atomic - Blondie',
      ],
      streamUrl: 'https://stream.nightride.fm/nightride.mp3',
      streamSourceName: 'Nightride FM',
    ),
    RadioStationModel(
      id: 'st_fever',
      name: 'Fever 105',
      genre: 'Disco & Funk Vice City',
      frequency: '105.7 FM',
      currentTrack: 'And the Beat Goes On',
      artist: 'The Whispers',
      icon: Icons.music_note_rounded,
      gradientColors: [AppColors.gold, Colors.orangeAccent],
      playlist: [
        'And the Beat Goes On - The Whispers',
        'Gotta Go Home - Boney M.',
        'Act Like You Know - Fat Larrys Band',
        'Juicy Fruit - Mtume',
      ],
      streamUrl: 'https://listen.radioking.com/radio/467555/stream/523739',
      streamSourceName: 'FM 80 Funky Music',
    ),
    RadioStationModel(
      id: 'st_vrock',
      name: 'V-Rock 101',
      genre: 'Hard Rock & Heavy Metal',
      frequency: '101.5 FM',
      currentTrack: 'Too Young to Fall in Love',
      artist: 'Mötley Crüe',
      icon: Icons.electric_bolt_rounded,
      gradientColors: [Colors.redAccent, Colors.deepOrange],
      playlist: [
        'Too Young to Fall in Love - Mötley Crüe',
        'Peace Sells - Megadeth',
        'Dangerous Bastard - Love Fist',
        'Cumin At Ya - Quiet Riot',
      ],
      streamUrl: 'http://mp3channels.webradio.rockantenne.de/heavy-metal',
      streamSourceName: 'Rock Antenne Heavy Metal',
    ),
    RadioStationModel(
      id: 'st_hiphop',
      name: 'Vice City Beat 99.1',
      genre: 'Hip-Hop & Trap 2026',
      frequency: '99.1 FM',
      currentTrack: 'Miami Vice Nights',
      artist: 'Vice City Posse',
      icon: Icons.speaker_group_rounded,
      gradientColors: [Colors.cyan, Colors.blueAccent],
      playlist: [
        'Miami Vice Nights - Vice City Posse',
        'Lucia & Jason Theme - Vice Sound',
        'Biscayne Boulevard - Florida Beats',
      ],
      streamUrl: 'http://icecast.skyrock.net/s/natio_mp3_128k',
      streamSourceName: 'Skyrock',
    ),
  ];

  @override
  Future<List<RadioStationModel>> getStations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _stations;
  }
}
