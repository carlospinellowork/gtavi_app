import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../domain/radio_station_model.dart';

/// Estado do player de rádio: qual estação está tocando (com áudio real via
/// stream de internet) e o status de reprodução.
class RadioPlayerState {
  final RadioStationModel? currentStation;
  final bool isPlaying;
  final bool isLoading;
  final double volume;
  final String? error;

  const RadioPlayerState({
    this.currentStation,
    this.isPlaying = false,
    this.isLoading = false,
    this.volume = 0.8,
    this.error,
  });

  RadioPlayerState copyWith({
    RadioStationModel? currentStation,
    bool? isPlaying,
    bool? isLoading,
    double? volume,
    String? error,
    bool clearError = false,
  }) {
    return RadioPlayerState(
      currentStation: currentStation ?? this.currentStation,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      volume: volume ?? this.volume,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controla um único [AudioPlayer] (just_audio) compartilhado por toda a
/// tela de rádio, trocando a URL de stream ao mudar de estação.
class RadioPlayerController extends StateNotifier<RadioPlayerState> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<PlayerState>? _playerStateSubscription;

  RadioPlayerController() : super(const RadioPlayerState()) {
    _player.setVolume(state.volume);
    _playerStateSubscription = _player.playerStateStream.listen((playerState) {
      if (!mounted) return;
      final playing = playerState.playing && playerState.processingState != ProcessingState.completed;
      if (state.isPlaying != playing) {
        state = state.copyWith(isPlaying: playing);
      }
    });
  }

  Future<void> playStation(RadioStationModel station) async {
    final isSameStation = state.currentStation?.id == station.id;

    if (isSameStation) {
      await togglePlayPause();
      return;
    }

    state = state.copyWith(currentStation: station, isLoading: true, clearError: true);
    try {
      await _player.setUrl(station.streamUrl);
      await _player.play();
    } catch (e) {
      state = state.copyWith(error: 'Não foi possível conectar a ${station.streamSourceName}.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> togglePlayPause() async {
    if (state.currentStation == null) return;
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> setVolume(double volume) async {
    state = state.copyWith(volume: volume);
    await _player.setVolume(volume);
  }

  Future<void> nextStation(List<RadioStationModel> stations) => _skip(stations, 1);

  Future<void> previousStation(List<RadioStationModel> stations) => _skip(stations, -1);

  Future<void> _skip(List<RadioStationModel> stations, int offset) async {
    if (stations.isEmpty) return;
    final current = state.currentStation;
    final currentIndex = current == null ? -1 : stations.indexWhere((s) => s.id == current.id);
    final nextIndex = (currentIndex + offset) % stations.length;
    await playStation(stations[nextIndex]);
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }
}

final radioPlayerProvider = StateNotifierProvider<RadioPlayerController, RadioPlayerState>((ref) {
  return RadioPlayerController();
});
