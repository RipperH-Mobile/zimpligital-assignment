import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/music_bloc/music_bloc.dart';
import '../../logic/music_bloc/music_event.dart';
import '../../logic/music_bloc/music_state.dart';

class PlayerDetailPage extends StatefulWidget {
  const PlayerDetailPage({super.key});

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        if (state is! MusicLoaded || state.currentMusic == null) {
          return const Scaffold(body: Center(child: Text("No Music")));
        }

        final current = state.currentMusic!;

        return Scaffold(
          backgroundColor: const Color(0xFF122333),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: const Color(0xFF122333),
                leading: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(current.imageUrl, width: 150, height: 150, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 15),
                        Text(current.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        Text(current.artist, style: const TextStyle(color: Colors.white70, fontSize: 14)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(state.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: Colors.white, size: 45),
                              onPressed: () => context.read<MusicBloc>().add(TogglePlayPause()),
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next, color: Colors.white, size: 35),
                              onPressed: () => context.read<MusicBloc>().add(SkipNext()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    tabs: const [
                      Tab(text: "UP NEXT"),
                      Tab(text: "LYRICS"),
                    ],
                  ),
                ),
              ),

              _tabController.index == 0
                  ? _buildUpNextList(state)
                  : _buildLyricsView(current.title),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUpNextList(MusicLoaded state) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final music = state.playlist[index];
          final isCurrent = music.id == state.currentMusic?.id;
          return Container(
            color: isCurrent ? Colors.white.withOpacity(0.1) : const Color(0xFF1B2C3B),
            child: ListTile(
              leading: isCurrent
                  ? const Icon(Icons.bar_chart, color: Colors.white)
                  : Image.network(music.imageUrl, width: 40),
              title: Text(music.title, style: const TextStyle(color: Colors.white, fontSize: 14)),
              onTap: () => context.read<MusicBloc>().add(SelectMusic(music)),
            ),
          );
        },
        childCount: state.playlist.length,
      ),
    );
  }

  Widget _buildLyricsView(String title) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(30),
        color: const Color(0xFF1B2C3B),
        child: Column(
          children: [
            Text(
              "เนื้อเพลง: $title\n\n(กำลังดึงข้อมูลเนื้อร้อง...)\n\n"
                  "เนื่องจาก data ของ youtube data ยังไม่มี อาจจะต้องหาวิธี modify ใหม่อีกรอบ มีการลองใช้ LRCLIB แต่ไม่มีเนื้อหา สามารถพัฒนาเพิ่มเติมได้ ขอ Remark ไว้ศึกษาครับ",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final TabBar _tabBar;
  @override double get minExtent => _tabBar.preferredSize.height;
  @override double get maxExtent => _tabBar.preferredSize.height;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: const Color(0xFF1B2C3B), child: _tabBar);
  }
  @override bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}