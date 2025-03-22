import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoModel {
  final String title;
  final String thumbnailUrl;
  final String videoUrl;

  VideoModel({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
  });
}

class VideoProvider with ChangeNotifier {
  final YoutubeExplode _youtubeExplode = YoutubeExplode();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<VideoModel> _videos = [];
  bool _isLoading = false;

  String? _currentAudioUrl;
  String? _currentThumbnailUrl;
  String? _currentVideoTitle;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  List<VideoModel> get videos => _videos;
  String? get currentAudioUrl => _currentAudioUrl;

  bool get isLoading => _isLoading;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get isPlaying => _audioPlayer.playing;
  String? get currentThumbnail => _currentThumbnailUrl;
  String? get currentTitle => _currentVideoTitle;

  VideoProvider() {
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });
  }

  /// Fetch video details for a list of YouTube URLs
  Future<void> fetchVideos(List<String> ytLinks) async {
    _isLoading = true;
    notifyListeners();

    List<VideoModel> fetchedVideos = [];

    for (var link in ytLinks) {
      try {
        final videoId = Uri.parse(link).pathSegments.last;
        final video = await _youtubeExplode.videos.get(videoId);

        fetchedVideos.add(
          VideoModel(
            title: video.title,
            thumbnailUrl: video.thumbnails.lowResUrl,
            videoUrl: link,
          ),
        );
      } catch (e) {
        debugPrint('Error fetching video: $e');
      }
    }

    _videos = fetchedVideos;
    _isLoading = false;
    notifyListeners();
  }

  /// Fetch audio stream and play the selected video
  Future<void> fetchAndPlayAudio(String url) async {
    _isLoading = true;
    notifyListeners();

    try {
      final videoId = Uri.parse(url).pathSegments.last;
      final video = await _youtubeExplode.videos.get(videoId);
      final manifest = await _youtubeExplode.videos.streamsClient.getManifest(
        videoId,
      );
      final audioStream = manifest.audioOnly.withHighestBitrate();

      _currentAudioUrl = audioStream.url.toString();
      _currentThumbnailUrl = video.thumbnails.maxResUrl;
      _currentVideoTitle = video.title;

      await _audioPlayer.setUrl(_currentAudioUrl!);
      _audioPlayer.play();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    notifyListeners();
  }

  Future<void> replayAudio() async {
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.play();
    notifyListeners();
  }

  Future<void> seek(Duration duration) async {
    await _audioPlayer.seek(duration);
    notifyListeners();
  }

  @override
  void dispose() {
    _youtubeExplode.close();
    _audioPlayer.dispose();
    super.dispose();
  }
}
