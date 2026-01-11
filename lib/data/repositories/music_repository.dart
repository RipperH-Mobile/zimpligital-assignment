import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/music_model.dart';

class MusicRepository {
  final String apiKey = 'AIzaSyAa6_6GOIhMIo8RRgcSY-8YbLsv7vEqHLU';

  Future<List<Music>> fetchPlaylist() async {
    final url = Uri.https('www.googleapis.com', '/youtube/v3/search', {
      'part': 'snippet',
      'q': 'เพลงไทยใหม่ล่าสุด',
      'type': 'video',
      'videoCategoryId': '10',
      'maxResults': '10',
      'key': apiKey,
    });
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'];

      return items.map((item) {
        final snippet = item['snippet'];
        final videoId = item['id']['videoId'];

        return Music(
          id: videoId,
          title: snippet['title'],
          artist: snippet['channelTitle'],
          url: 'https://www.youtube.com/watch?v=$videoId',
          imageUrl: snippet['thumbnails']['high']['url'],
        );
      }).toList();
    } else {
      throw Exception('ไม่สามารถดึงข้อมูลจาก YouTube ได้');
    }
  }
}