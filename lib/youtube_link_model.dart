import 'package:cloud_firestore/cloud_firestore.dart';

class YoutubeLink {
  final String id;
  final String userId;
  final String youtubeLink;
  final String? title;
  final String? thumbnailUrl;
  final FieldValue timestamp;

  YoutubeLink({
    required this.id,
    required this.userId,
    required this.youtubeLink,
    this.title,
    this.thumbnailUrl,
    required this.timestamp,
  });

  factory YoutubeLink.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return YoutubeLink(
      id: snapshot.id,
      userId: data?['userId'] ?? '',
      youtubeLink: data?['youtubeLink'] ?? '',
      title: data?['title'],
      thumbnailUrl: data?['thumbnailUrl'],
      // Timestamp will be handled by Firestore, so we can pass it directly
      // or if it's null (e.g. during local object creation before saving),
      // it will be set by toFirestore.
      // For fromFirestore, we expect it to exist.
      timestamp: data?['timestamp'] ?? FieldValue.serverTimestamp(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'youtubeLink': youtubeLink,
      if (title != null) 'title': title,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      'timestamp': timestamp, // This will handle both new and existing objects correctly.
                               // For new objects, ensure timestamp is FieldValue.serverTimestamp()
                               // For existing, it will be the actual Timestamp from Firestore
    };
  }
}
