import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for MethodChannel
import 'package:music_player/youtube_audio_player.dart';
// import 'package:music_player/yt_links.dart'; // Not needed anymore
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'video_provider.dart'; // Make sure this imports the updated VideoProvider
import 'package:music_player/youtube_link_model.dart'; // Import YoutubeLink model

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = MethodChannel('com.example.music_player/share'); // Same channel name

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_handleSharedLink);
  }

  Future<void> _handleSharedLink(MethodCall call) async {
    if (call.method == "handleSharedLink") {
      final String sharedLink = call.arguments as String;
      if (sharedLink.isNotEmpty) {
        // Ensure context is still valid before using it, especially for ScaffoldMessenger
        if (!mounted) return;
        final videoProvider = Provider.of<VideoProvider>(context, listen: false);
        try {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Received link via share: $sharedLink. Adding...')),
          );
          await videoProvider.addYoutubeLink(sharedLink);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Link added successfully via share!')),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add shared link: ${e.toString()}')),
          );
        }
      }
    }
  }

  void _showAddLinkDialog(BuildContext context) {
    final TextEditingController linkController = TextEditingController();
    // Use context from the builder if using a different context for VideoProvider
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add YouTube Link'),
          content: TextField(
            controller: linkController,
            decoration: InputDecoration(hintText: 'Paste YouTube link here'),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                final String link = linkController.text.trim();
                if (link.isNotEmpty) {
                  // It's good practice to hide the current SnackBar before showing a new one.
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Adding link...')),
                  );
                  try {
                    await videoProvider.addYoutubeLink(link);
                    Navigator.of(dialogContext).pop(); // Close dialog on success
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Remove "Adding"
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Link added successfully!')),
                    );
                  } catch (e) {
                    // Navigator.of(dialogContext).pop(); // Dialog is already popped or should be popped after error
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Remove "Adding"
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Failed to add link: ${e.toString()}')),
                    );
                     // Optionally, keep the dialog open on error by not popping here.
                     // For this implementation, let's pop it.
                    if (Navigator.of(dialogContext).canPop()) { // check if dialog is still open
                         Navigator.of(dialogContext).pop();
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Link cannot be empty')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('EarSync Music')), // Updated title
      body: videoProvider.isLoading && videoProvider.videos.isEmpty // Show loading only if list is empty
          ? const Center(child: CircularProgressIndicator())
          : videoProvider.videos.isEmpty
              ? const Center(
                  child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No links found. Tap the "+" button to add your first YouTube link!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ))
              : ListView.builder(
                  itemCount: videoProvider.videos.length,
                  itemBuilder: (context, index) {
                    final YoutubeLink video = videoProvider.videos[index]; // Use YoutubeLink type

                    return ListTile(
                      leading: (video.thumbnailUrl == null ||
                              video.thumbnailUrl!.isEmpty)
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 80,
                                height: 50,
                                color: Colors.white,
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: video.thumbnailUrl!,
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
                                child: const Icon(Icons.broken_image,
                                    color: Colors.white),
                              ),
                            ),
                      title: Text(
                        video.title ?? "No title available", // Handle null title
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        video.youtubeLink, // Display the link as subtitle
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YouTubeAudioPlayer(
                                videoUrl: video.youtubeLink), // Use video.youtubeLink
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLinkDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add YouTube Link',
      ),
    );
  }
}