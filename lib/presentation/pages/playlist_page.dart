import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/music_bloc/music_bloc.dart';
import '../../logic/music_bloc/music_event.dart';
import '../../logic/music_bloc/music_state.dart';
import '../widgets/mini_player.dart';

class PlaylistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Playlist", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          BlocBuilder<MusicBloc, MusicState>(
            builder: (context, state) {
              if (state is MusicLoading) return const Center(child: CircularProgressIndicator());
              if (state is MusicLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: state.playlist.length,
                  itemBuilder: (context, index) {
                    final music = state.playlist[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(music.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      title: Text(music.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(music.artist),
                      trailing: const Icon(Icons.play_arrow_outlined),
                      onTap: () => context.read<MusicBloc>().add(SelectMusic(music)),
                    );
                  },
                );
              }
              return const Center(child: Text("Error loading music"));
            },
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: MiniPlayer()),
        ],
      ),
    );
  }
}