class CommunityPost {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String? image;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool isLiked;

  const CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    this.image,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });

  CommunityPost copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? content,
    String? image,
    DateTime? createdAt,
    int? likes,
    int? comments,
    bool? isLiked,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  String toString() {
    return 'CommunityPost(id: $id, authorName: $authorName, content: $content, likes: $likes, comments: $comments)';
  }
}
