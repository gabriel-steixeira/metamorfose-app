import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentPhoto {
  final String id;
  final String url;
  final Timestamp timestamp;
  final String storagePath;

  CurrentPhoto({
    required this.id,
    required this.url,
    required this.timestamp,
    required this.storagePath,
  });

  factory CurrentPhoto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CurrentPhoto(
      id: doc.id,
      url: data['url'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      storagePath: data['storage_path'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'timestamp': timestamp,
      'storage_path': storagePath,
    };
  }
} 