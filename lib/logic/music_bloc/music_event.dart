import 'package:equatable/equatable.dart';
import '../../data/models/music_model.dart';

abstract class MusicEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPlaylist extends MusicEvent {}
class TogglePlayPause extends MusicEvent {}
class SkipNext extends MusicEvent {}

class SelectMusic extends MusicEvent {
  final Music music;
  SelectMusic(this.music);
  @override
  List<Object?> get props => [music];
}