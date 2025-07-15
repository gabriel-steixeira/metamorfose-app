import 'package:cloud_firestore/cloud_firestore.dart';

class PlantPhoto {
  final String id;
  final String storagePath;
  final String url;
  final String? thumbnailUrl;
  final Timestamp timestamp;
  final String dateKey;
  final bool isMainPhoto;
  final String? userNotes;

  PlantPhoto({
    required this.id,
    required this.storagePath,
    required this.url,
    this.thumbnailUrl,
    required this.timestamp,
    required this.dateKey,
    required this.isMainPhoto,
    this.userNotes,
  });

  factory PlantPhoto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlantPhoto(
      id: doc.id,
      storagePath: data['storage_path'] ?? '',
      url: data['url'] ?? '',
      thumbnailUrl: data['thumbnail_url'],
      timestamp: data['timestamp'] ?? Timestamp.now(),
      dateKey: data['date_key'] ?? '',
      isMainPhoto: data['is_main_photo'] ?? false,
      userNotes: data['user_notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storage_path': storagePath,
      'url': url,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      'timestamp': timestamp,
      'date_key': dateKey,
      'is_main_photo': isMainPhoto,
      if (userNotes != null) 'user_notes': userNotes,
    };
  }
} 