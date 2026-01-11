import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'data/repositories/music_repository.dart';
import 'logic/music_bloc/music_bloc.dart';
import 'logic/music_bloc/music_event.dart';
import 'logic/music_bloc/music_state.dart';
import 'presentation/pages/playlist_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MusicRepository(),
      child: BlocProvider(
        create: (context) => MusicBloc(context.read<MusicRepository>())..add(LoadPlaylist()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const GlobalPlayerWrapper(),
        ),
      ),
    );
  }
}

class GlobalPlayerWrapper extends StatefulWidget {
  const GlobalPlayerWrapper({super.key});

  @override
  State<GlobalPlayerWrapper> createState() => _GlobalPlayerWrapperState();
}

class _GlobalPlayerWrapperState extends State<GlobalPlayerWrapper> {
  YoutubePlayerController? _controller;
  String? _lastVideoId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MusicBloc, MusicState>(
      listener: (context, state) {
        if (state is MusicLoaded && state.currentMusic != null) {
          final videoId = state.currentMusic!.id;

          if (_controller == null) {
            _controller = YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(autoPlay: true, hideControls: true),
            );
            _lastVideoId = videoId;
            setState(() {});
          } else {
            if (_lastVideoId != videoId) {
              _controller!.load(videoId);
              _lastVideoId = videoId;
            }

            if (state.isPlaying) {
              _controller!.play();
            } else {
              _controller!.pause();
            }
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            PlaylistPage(),
            if (_controller != null)
              Offstage(
                offstage: true,
                child: YoutubePlayer(
                  controller: _controller!,
                  onReady: () => _controller!.play(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}