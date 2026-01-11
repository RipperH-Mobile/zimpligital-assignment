import 'package:equatable/equatable.dart';

class Music extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String url;
  final String imageUrl;

  const Music({required this.id, required this.title, required this.artist, required this.url, required this.imageUrl});

  @override
  List<Object?> get props => [id, title, artist, url, imageUrl];
}