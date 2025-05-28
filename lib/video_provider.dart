import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:music_player/firestore_service.dart';
import 'package:music_player/auth_service.dart';
import 'package:music_player/youtube_link_model.dart';

class VideoProvider with ChangeNotifier {
  final YoutubeExplode _youtubeExplode = YoutubeExplode();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FirestoreService _firestoreService;
  final AuthService _authService;

  List<YoutubeLink> _videos = [];
  bool _isLoading = false;
  StreamSubscription? _linkSubscription;

  String? _currentAudioUrl;
  String? _currentPlayingYoutubeLink; // To store the original link of the currently playing audio
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  List<YoutubeLink> get videos => _videos;
  String? get currentAudioUrl => _currentAudioUrl;
  YoutubeLink? get currentPlayingVideo {
    if (_currentPlayingYoutubeLink == null) return null;
    try {
      return _videos.firstWhere((link) => link.youtubeLink == _currentPlayingYoutubeLink);
    } catch (e) {
      return null; // Not found
    }
  }


  bool get isLoading => _isLoading;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get isPlaying => _audioPlayer.playing;
  String? get currentThumbnail => currentPlayingVideo?.thumbnailUrl;
  String? get currentTitle => currentPlayingVideo?.title;

  VideoProvider(this._authService, this._firestoreService) {
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });
    _authService.addListener(_onAuthStateChanged);
    _onAuthStateChanged(); // Initial check
  }

  void _onAuthStateChanged() {
    if (_authService.user != null) {
      fetchLinksFromFirestore();
    } else {
      _videos.clear();
      _linkSubscription?.cancel();
      _isLoading = false;
      notifyListeners();
    }
  }

  void fetchLinksFromFirestore() {
    if (_authService.user == null) return;
    _isLoading = true;
    notifyListeners();

    _linkSubscription?.cancel(); // Cancel previous subscription
    _linkSubscription = _firestoreService.getLinks(_authService.user!.uid).listen(
      (links) {
        _videos = links;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        // Handle error, e.g., set an error message
        print("Error fetching links: $error");
        notifyListeners();
      },
    );
  }

  Future<void> addYoutubeLink(String youtubeLink) async {
    if (_authService.user == null) {
      throw Exception('User not logged in.');
    }
    // Consider a specific loading state for adding if general _isLoading is too broad
    // Set a specific loading state for this operation if you have one,
    // otherwise, manage the general _isLoading carefully.
    _isLoading = true;
    notifyListeners();
    try {
      await _firestoreService.addLink(_authService.user!.uid, youtubeLink);
      // The stream will update the list.
    } catch (e) {
      print("Error adding link: $e");
      // Optionally, set an error state for the UI to show feedback
      rethrow; // Rethrow to let the caller handle UI feedback if necessary
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch audio stream and play the selected video
  Future<void> fetchAndPlayAudio(String youtubeLinkUrl) async {
    _isLoading = true;
    notifyListeners();

    try {
      // The youtubeLinkUrl is the unique identifier for the video in our list
      _currentPlayingYoutubeLink = youtubeLinkUrl;

      final videoId = VideoId.parse(youtubeLinkUrl); // Use VideoId.parse for robustness
      // We don't need to fetch video details (title, thumbnail) here if they are already in YoutubeLink model
      // final video = await _youtubeExplode.videos.get(videoId);
      final manifest = await _youtubeExplode.videos.streamsClient.getManifest(videoId);
      final audioStream = manifest.audioOnly.withHighestBitrate();

      _currentAudioUrl = audioStream.url.toString();
      // _currentThumbnailUrl and _currentVideoTitle are now derived from currentPlayingVideo getter

      await _audioPlayer.setUrl(_currentAudioUrl!);
      _audioPlayer.play();
    } catch (e) {
      debugPrint('Error fetching or playing audio: $e');
      _currentPlayingYoutubeLink = null; // Reset if error
      // Optionally, set an error state for the UI
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
    _authService.removeListener(_onAuthStateChanged);
    _linkSubscription?.cancel();
    _youtubeExplode.close();
    _audioPlayer.dispose();
    super.dispose();
  }
}
