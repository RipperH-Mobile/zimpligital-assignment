import 'package:equatable/equatable.dart';
import '../../data/models/music_model.dart';

abstract class MusicState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MusicLoading extends MusicState {}

class MusicLoaded extends MusicState {
  final List<Music> playlist;
  final Music? currentMusic;
  final bool isPlaying;

  MusicLoaded({required this.playlist, this.currentMusic, this.isPlaying = false});

  @override
  List<Object?> get props => [playlist, currentMusic, isPlaying];
}

class MusicError extends MusicState {}