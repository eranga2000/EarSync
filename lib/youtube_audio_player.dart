import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'video_provider.dart';

class YouTubeAudioPlayer extends StatefulWidget {
  final String videoUrl;
  const YouTubeAudioPlayer({super.key, required this.videoUrl});

  @override
  State<YouTubeAudioPlayer> createState() => _YouTubeAudioPlayerState();
}

class _YouTubeAudioPlayerState extends State<YouTubeAudioPlayer> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (mounted) {
        final videoProvider = Provider.of<VideoProvider>(
          context,
          listen: false,
        );
        await videoProvider.fetchAndPlayAudio(widget.videoUrl);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (videoProvider.currentThumbnail != null)
              Column(
                children: [
                  Image.network(videoProvider.currentThumbnail!),
                  const SizedBox(height: 8),
                  Text(
                    videoProvider.currentTitle ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            const SizedBox(height: 16),
            if (videoProvider.currentAudioUrl != null)
              Column(
                children: [
                  ProgressBar(
                    progress: videoProvider.position,
                    total: videoProvider.duration,
                    onSeek: (duration) => videoProvider.seek(duration),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: videoProvider.replayAudio,
                        icon: const Icon(Icons.replay_10),
                        iconSize: 32,
                      ),
                      IconButton(
                        onPressed: videoProvider.togglePlayPause,
                        icon: Icon(
                          videoProvider.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        iconSize: 32,
                      ),
                      IconButton(
                        onPressed:
                            () => videoProvider.seek(
                              videoProvider.position +
                                  const Duration(seconds: 10),
                            ),
                        icon: const Icon(Icons.forward_10),
                        iconSize: 32,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
