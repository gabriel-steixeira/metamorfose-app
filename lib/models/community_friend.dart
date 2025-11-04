class CommunityFriend {
  final String id;
  final String name;
  final String avatar;
  final String? phase;
  final bool isOnline;
  final DateTime lastActive;

  const CommunityFriend({
    required this.id,
    required this.name,
    required this.avatar,
    this.phase,
    this.isOnline = false,
    required this.lastActive,
  });

  CommunityFriend copyWith({
    String? id,
    String? name,
    String? avatar,
    String? phase,
    bool? isOnline,
    DateTime? lastActive,
  }) {
    return CommunityFriend(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phase: phase ?? this.phase,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  @override
  String toString() {
    return 'CommunityFriend(id: $id, name: $name, isOnline: $isOnline)';
  }
}
