import 'package:flutter_bloc/flutter_bloc.dart';
import 'music_event.dart';
import 'music_state.dart';
import '../../data/repositories/music_repository.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final MusicRepository repository;

  MusicBloc(this.repository) : super(MusicLoading()) {
    on<LoadPlaylist>(_onLoadPlaylist);
    on<SelectMusic>(_onSelectMusic);
    on<TogglePlayPause>(_onTogglePlayPause);
    on<SkipNext>(_onSkipNext);
  }

  void _onSkipNext(SkipNext event, Emitter<MusicState> emit) {
    if (state is! MusicLoaded) return;
    final currentState = state as MusicLoaded;

    final currentIndex = currentState.playlist.indexWhere(
            (m) => m.id == currentState.currentMusic?.id
    );

    if (currentIndex != -1) {
      final nextIndex = (currentIndex + 1) % currentState.playlist.length;
      final nextMusic = currentState.playlist[nextIndex];

      add(SelectMusic(nextMusic));
    }
  }

  Future<void> _onLoadPlaylist(LoadPlaylist event, Emitter<MusicState> emit) async {
    try {
      print("Fetching playlist...");
      final playlist = await repository.fetchPlaylist();
      print("Playlist loaded: ${playlist.length} items");
      emit(MusicLoaded(playlist: playlist));
    } catch (e) {
      print("Error fetching playlist: $e");
      emit(MusicError());
    }
  }
  void _onSelectMusic(SelectMusic event, Emitter<MusicState> emit) {
    if (state is! MusicLoaded) return;
    final currentState = state as MusicLoaded;


    emit(MusicLoaded(
      playlist: currentState.playlist,
      currentMusic: event.music,
      isPlaying: true,
    ));
  }

  void _onTogglePlayPause(TogglePlayPause event, Emitter<MusicState> emit) {
    if (state is MusicLoaded) {
      final currentState = state as MusicLoaded;
      emit(MusicLoaded(
        playlist: currentState.playlist,
        currentMusic: currentState.currentMusic,
        isPlaying: !currentState.isPlaying,
      ));
    }
  }
}