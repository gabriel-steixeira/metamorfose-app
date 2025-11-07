import 'package:metamorfose_flutter/models/community_post.dart';
import 'package:metamorfose_flutter/models/community_friend.dart';

/// Serviço para gerenciamento de dados da comunidade com dados simulados
class CommunityService {
  /// Mock data - Posts
  static final List<CommunityPost> _mockPosts = [
    CommunityPost(
      id: '1',
      authorId: 'user1',
      authorName: 'Sanji',
      authorAvatar: 'assets/images/massdata/community/sanji.png',
      content:
          'Estou muito feliz com meu progresso na terapia! Cada dia é um novo passo em direção ao bem-estar. 🌱✨ #Metamorfose #BemEstar',
      image: 'assets/images/massdata/community/post-1.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 24,
      comments: 8,
      isLiked: true,
    ),
    CommunityPost(
      id: '2',
      authorId: 'user2',
      authorName: 'Ester',
      authorAvatar: 'assets/images/massdata/community/ester.png',
      content:
          'Meditação tem sido fundamental na minha jornada. Alguém mais pratica aqui? 🧘‍♂️',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 15,
      comments: 12,
      isLiked: false,
    ),
    CommunityPost(
      id: '3',
      authorId: 'user3',
      authorName: 'Gabriel',
      authorAvatar: 'assets/images/massdata/community/gabriel.png',
      content: 'Minha plantinha está crescendo junto comigo nessa jornada! 🌿',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likes: 42,
      comments: 15,
      isLiked: false,
    ),
  ];

  /// Mock data - Friends
  static final List<CommunityFriend> _mockFriends = [
    CommunityFriend(
      id: 'friend1',
      name: 'Evelin',
      avatar: 'assets/images/massdata/community/eve.png',
      phase: 'Borboleta',
      isOnline: true,
      lastActive: DateTime.now(),
    ),
    CommunityFriend(
      id: 'friend2',
      name: 'Donax',
      avatar: 'assets/images/massdata/community/donax.png',
      phase: 'Crisálida',
      isOnline: false,
      lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    CommunityFriend(
      id: 'friend3',
      name: 'Lana',
      avatar: 'assets/images/massdata/community/lana.png',
      phase: 'Lagarta',
      isOnline: true,
      lastActive: DateTime.now(),
    ),
    CommunityFriend(
      id: 'friend4',
      name: 'Ester',
      avatar: 'assets/images/massdata/community/ester.png',
      phase: 'Ovo',
      isOnline: false,
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    CommunityFriend(
      id: 'friend4',
      name: 'Gabriel',
      avatar: 'assets/images/massdata/community/gabriel.png',
      phase: 'Ovo',
      isOnline: false,
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  /// Carrega posts da comunidade com dados simulados
  Future<List<CommunityPost>> loadPosts() async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 1000));
    return _mockPosts;
  }

  /// Carrega lista de amigos com dados simulados
  Future<List<CommunityFriend>> loadFriends() async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 1000));
    return _mockFriends;
  }

  /// Compartilha um post com a comunidade
  Future<bool> sharePost(Map<String, dynamic> postData) async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 1500));

    // Adicionar o post aos dados simulados
    _mockPosts.insert(
        0,
        CommunityPost(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          authorId: 'currentUser',
          authorName: 'Você',
          authorAvatar:
              'assets/images/massdata/community/eve.png', // Usando o avatar da Eve para o usuário atual
          content: postData['content'],
          image: postData['image'],
          createdAt: DateTime.now(),
          likes: 0,
          comments: 0,
          isLiked: false,
        ));

    return true;
  }

  /// Curte ou descurte um post
  Future<bool> toggleLike(String postId) async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    final post = _mockPosts.firstWhere((p) => p.id == postId);
    final index = _mockPosts.indexOf(post);

    _mockPosts[index] = post.copyWith(
      isLiked: !post.isLiked,
      likes: post.isLiked ? post.likes - 1 : post.likes + 1,
    );

    return true;
  }

  /// Adiciona um comentário a um post
  Future<bool> addComment(String postId, String comment) async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 1000));

    final post = _mockPosts.firstWhere((p) => p.id == postId);
    final index = _mockPosts.indexOf(post);

    _mockPosts[index] = post.copyWith(
      comments: post.comments + 1,
    );

    return true;
  }
}
