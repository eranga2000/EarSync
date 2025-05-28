import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_player/youtube_audio_player.dart';
import 'package:music_player/yt_links.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'video_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      Provider.of<VideoProvider>(context, listen: false).fetchVideos(ytLinks);
    }
  });
    
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);

    return Scaffold(
  appBar: AppBar(title: const Text('YouTube Audio Player')),
  body: videoProvider.isLoading
      ? const Center(child: CircularProgressIndicator())
      : ListView.builder(
          itemCount: videoProvider.videos.length,
          itemBuilder: (context, index) {
            final video = videoProvider.videos[index];

            return ListTile(
              leading: (video.thumbnailUrl == null || video.thumbnailUrl!.isEmpty)
                  ? Shimmer.fromColors( // Or your preferred placeholder if thumbnail URL is not yet available
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 80,
                        height: 50,
                        color: Colors.white,
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: video.thumbnailUrl!, // Now we know it's not null here
                      width: 80,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 80,
                          height: 50,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 80,
                        height: 50,
                        color: Colors.grey,
                        child: const Icon(Icons.broken_image, color: Colors.white),
                      ),
                    ),
              title: Text(
                video.title ?? "Loading title...", // Or handle empty string if preferred
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
             
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YouTubeAudioPlayer(videoUrl: video.videoUrl),
                  ),
                );
              },
            );
          },
        ),
);
  }
}


/*
 
 Scaffold(
      appBar: AppBar(title: const Text('YouTube Audio Player')),
      body:
          videoProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: videoProvider.videos.length,
                itemBuilder: (context, index) {
                  final video = videoProvider.videos[index];

                  return ListTile(
                    leading: Image.network(
                      video.thumbnailUrl,
                      width: 80,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  YouTubeAudioPlayer(videoUrl: video.videoUrl),
                        ),
                      );
                    },
                  );
                },
              ),
    );
 
 */