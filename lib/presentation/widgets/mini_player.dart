import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/music_bloc/music_bloc.dart';
import '../../logic/music_bloc/music_event.dart';
import '../../logic/music_bloc/music_state.dart';
import '../pages/player_detail_page.dart';

class MiniPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        if (state is MusicLoaded && state.currentMusic != null) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlayerDetailPage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(state.currentMusic!.imageUrl, width: 50, height: 50),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.currentMusic!.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(state.currentMusic!.artist, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(state.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, size: 40),
                    onPressed: () => context.read<MusicBloc>().add(TogglePlayPause()),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}