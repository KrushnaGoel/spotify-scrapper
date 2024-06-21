// playlist_screen.dart

import 'package:flutter/material.dart';
import 'package:spotify/song.dart';

class PlaylistScreen extends StatefulWidget {
  final String playlistName;
  final List<Song> tracks;
  final List<Song> downloadedSongs;

  PlaylistScreen({
    required this.playlistName,
    required this.tracks,
    required this.downloadedSongs,
  });

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Set<String> downloadedTrackIds = {};

  @override
  void initState() {
    super.initState();
    // Initialize downloadedTrackIds with already downloaded songs
    downloadedTrackIds =
        widget.downloadedSongs.map((track) => track.name).toSet();
  }

  void _downloadSong(Song track) {
    setState(() {
      downloadedTrackIds.add(track.name);
      widget.downloadedSongs.add(track);
    });
  }

  void _downloadAllSongs() {
    setState(() {
      for (var track in widget.tracks) {
        if (!downloadedTrackIds.contains(track.name)) {
          downloadedTrackIds.add(track.name);
          widget.downloadedSongs.add(track);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadAllSongs,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.tracks.length,
        itemBuilder: (context, index) {
          final track = widget.tracks[index];
          final isDownloaded = downloadedTrackIds.contains(track.name);
          return ListTile(
            title: Text('${track.name} by ${track.artists.first}'),
            trailing: isDownloaded
                ? const Icon(Icons.check, color: Colors.green)
                : IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () => _downloadSong(track),
                  ),
          );
        },
      ),
    );
  }
}
