import 'models.dart';
import 'api_client.dart';

abstract class GameRepository {
  Future<List<GameSummary>> listGames({String? q});
  Future<GameDetails> getGameDetails(String slug);
  // Community
  Future<List<CommunityPost>> listCommunityPosts(String gameId);
  Future<CommunityPost> createCommunityPost(String gameId, String content, {String? imageUrl});
  // Admin
  Future<void> banUser(String userId);
  Future<void> unbanUser(String userId);
  Future<void> giftGame(String userId, String gameId);
  Future<void> deletePost(String postId);
}

class ApiGameRepository implements GameRepository {
  final ApiClient _api;
  ApiGameRepository(this._api);

  @override
  Future<List<GameSummary>> listGames({String? q}) => _api.listGames(q: q);

  @override
  Future<GameDetails> getGameDetails(String slug) => _api.getGameDetails(slug);

  @override
  Future<List<CommunityPost>> listCommunityPosts(String gameId) =>
      _api.listCommunityPosts(gameId);

  @override
  Future<CommunityPost> createCommunityPost(String gameId, String content, {String? imageUrl}) =>
      _api.createCommunityPost(gameId, content, imageUrl: imageUrl);

  @override
  Future<void> banUser(String userId) => _api.banUser(userId);

  @override
  Future<void> unbanUser(String userId) => _api.unbanUser(userId);

  @override
  Future<void> giftGame(String userId, String gameId) =>
      _api.giftGame(userId, gameId);

  @override
  Future<void> deletePost(String postId) => _api.deletePost(postId);
}

class HardcodedGameRepository implements GameRepository {
  static final List<GameSummary> _games = [
    GameSummary(
      id: '1',
      slug: 'cyberpunk-2077',
      title: 'Cyberpunk 2077',
      shortDescription: 'RPG',
      priceCents: 2999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg',
      releaseDate: '2020-12-10',
      rating: 4.5,
      isFeatured: true,
    ),
    GameSummary(
      id: '2',
      slug: 'the-witcher-3',
      title: 'The Witcher 3',
      shortDescription: 'RPG',
      priceCents: 1999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/292030/header.jpg',
      releaseDate: '2015-05-18',
      rating: 4.9,
      isFeatured: true,
      isTopSeller: true,
    ),
    GameSummary(
      id: '3',
      slug: 'counter-strike-2',
      title: 'Counter-Strike 2',
      shortDescription: 'FPS',
      priceCents: 0,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/730/header.jpg',
      releaseDate: '2023-09-27',
      rating: 4.3,
      isNew: true,
      isTopSeller: true,
    ),
    GameSummary(
      id: '4',
      slug: 'elden-ring',
      title: 'Elden Ring',
      shortDescription: 'Action RPG',
      priceCents: 4999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1245620/header.jpg',
      releaseDate: '2022-02-25',
      rating: 4.8,
      isFeatured: true,
      isTopSeller: true,
    ),
    GameSummary(
      id: '5',
      slug: 'minecraft',
      title: 'Minecraft',
      shortDescription: 'Sandbox',
      priceCents: 2699,
      currency: 'USD',
      headerImageUrl:
          'https://upload.wikimedia.org/wikipedia/en/5/51/Minecraft_cover.png',
      releaseDate: '2011-11-18',
      rating: 4.7,
      isTopSeller: true,
    ),
    GameSummary(
      id: '6',
      slug: 'dota-2',
      title: 'Dota 2',
      shortDescription: 'MOBA',
      priceCents: 0,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/570/header.jpg',
      releaseDate: '2013-07-09',
      rating: 4.2,
      isTopSeller: true,
    ),
    GameSummary(
      id: '7',
      slug: 'red-dead-2',
      title: 'Red Dead 2',
      shortDescription: 'Acción',
      priceCents: 3999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1174180/header.jpg',
      releaseDate: '2018-10-26',
      rating: 4.9,
      isFeatured: true,
    ),
    GameSummary(
      id: '8',
      slug: 'gta-v',
      title: 'GTA V',
      shortDescription: 'Acción',
      priceCents: 1999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/271590/header.jpg',
      releaseDate: '2013-09-17',
      rating: 4.4,
      isTopSeller: true,
    ),
    GameSummary(
      id: '9',
      slug: 'baldurs-gate-3',
      title: 'Baldur\'s Gate 3',
      shortDescription: 'RPG',
      priceCents: 5999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1086940/header.jpg',
      releaseDate: '2023-08-03',
      rating: 4.9,
      isNew: true,
      isFeatured: true,
      isTopSeller: true,
    ),
    GameSummary(
      id: '10',
      slug: 'starfield',
      title: 'Starfield',
      shortDescription: 'RPG Espacial',
      priceCents: 6999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1716740/header.jpg',
      releaseDate: '2023-09-06',
      rating: 3.8,
      isNew: true,
    ),
    GameSummary(
      id: '11',
      slug: 'hades-ii',
      title: 'Hades II',
      shortDescription: 'Roguelike',
      priceCents: 2999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1145350/header.jpg',
      releaseDate: '2024-05-06',
      rating: 4.9,
      isNew: true,
      isFeatured: true,
    ),
    GameSummary(
      id: '12',
      slug: 'helldivers-2',
      title: 'Helldivers 2',
      shortDescription: 'Shooter Coop',
      priceCents: 3999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/553850/header.jpg',
      releaseDate: '2024-02-08',
      rating: 4.6,
      isNew: true,
      isTopSeller: true,
    ),
    GameSummary(
      id: '13',
      slug: 'stardew-valley',
      title: 'Stardew Valley',
      shortDescription: 'Simulación',
      priceCents: 1499,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/413150/header.jpg',
      releaseDate: '2016-02-26',
      rating: 4.9,
    ),
    GameSummary(
      id: '14',
      slug: 'terraria',
      title: 'Terraria',
      shortDescription: 'Aventura',
      priceCents: 999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/105600/header.jpg',
      releaseDate: '2011-05-16',
      rating: 4.8,
    ),
    GameSummary(
      id: '15',
      slug: 'apex-legends',
      title: 'Apex Legends',
      shortDescription: 'Battle Royale',
      priceCents: 0,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1172470/header.jpg',
      releaseDate: '2019-02-04',
      rating: 4.1,
      isTopSeller: true,
    ),
    GameSummary(
      id: '16',
      slug: 'rust',
      title: 'Rust',
      shortDescription: 'Supervivencia',
      priceCents: 3999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/252490/header.jpg',
      releaseDate: '2018-02-08',
      rating: 4.0,
    ),
    GameSummary(
      id: '17',
      slug: 'valorant',
      title: 'Valorant',
      shortDescription: 'Tactical Shooter',
      priceCents: 0,
      currency: 'USD',
      headerImageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/f/fc/Valorant_logo_-_pink_color_version.png',
      releaseDate: '2020-06-02',
      rating: 4.4,
    ),
    GameSummary(
      id: '18',
      slug: 'league-of-legends',
      title: 'League of Legends',
      shortDescription: 'MOBA',
      priceCents: 0,
      currency: 'USD',
      headerImageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/7/77/League_of_Legends_logo.png',
      releaseDate: '2009-10-27',
      rating: 4.0,
    ),
    GameSummary(
      id: '19',
      slug: 'hollow-knight',
      title: 'Hollow Knight',
      shortDescription: 'Metroidvania',
      priceCents: 1499,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/367520/header.jpg',
      releaseDate: '2017-02-24',
      rating: 4.9,
    ),
    GameSummary(
      id: '20',
      slug: 'outer-wilds',
      title: 'Outer Wilds',
      shortDescription: 'Exploración',
      priceCents: 2499,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/753640/header.jpg',
      releaseDate: '2019-05-28',
      rating: 4.9,
    ),
    GameSummary(
      id: '21',
      slug: 'sea-of-thieves',
      title: 'Sea of Thieves',
      shortDescription: 'Piratas',
      priceCents: 3999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1172620/header.jpg',
      releaseDate: '2018-03-20',
      rating: 4.3,
    ),
    GameSummary(
      id: '22',
      slug: 'forza-horizon-5',
      title: 'Forza Horizon 5',
      shortDescription: 'Carreras',
      priceCents: 5999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1551360/header.jpg',
      releaseDate: '2021-11-09',
      rating: 4.7,
    ),
    GameSummary(
      id: '23',
      slug: 'it-takes-two',
      title: 'It Takes Two',
      shortDescription: 'Cooperativo',
      priceCents: 3999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1426210/header.jpg',
      releaseDate: '2021-03-26',
      rating: 4.9,
    ),
    GameSummary(
      id: '24',
      slug: 'lethal-company',
      title: 'Lethal Company',
      shortDescription: 'Terror Coop',
      priceCents: 999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1966720/header.jpg',
      releaseDate: '2023-10-23',
      rating: 4.8,
      isNew: true,
      isTopSeller: true,
    ),
  ];

  static final Map<String, List<CommunityPost>> _postsByGameId = {
    '4': [
      CommunityPost(
        id: 'p-elden-1',
        username: 'Admin',
        content: 'Consejo: si te cuesta un boss, cambia de build y sube vigor.',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      CommunityPost(
        id: 'p-elden-2',
        username: 'Gamer',
        content: 'Increíble el diseño del mundo. ¿Cuál zona te gustó más?',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
    ],
    '6': [
      CommunityPost(
        id: 'p-dota-1',
        username: 'SupportMain',
        content: '¿Qué héroe recomiendan para empezar como support?',
        createdAt: DateTime.now().subtract(const Duration(hours: 11)),
      ),
    ],
    '13': [
      CommunityPost(
        id: 'p-sv-1',
        username: 'Farmer',
        content: 'Año 2 y recién logro optimizar el invernadero. Tips?',
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      ),
    ],
  };

  @override
  Future<List<GameSummary>> listGames({String? q}) async {
    if (q == null || q.isEmpty) return _games;
    return _games
        .where((g) => g.title.toLowerCase().contains(q.toLowerCase()))
        .toList();
  }

  @override
  Future<GameDetails> getGameDetails(String slug) async {
    final s = _games.firstWhere((g) => g.slug == slug);
    return GameDetails(
      id: s.id,
      slug: s.slug,
      title: s.title,
      shortDescription: s.shortDescription,
      longDescription: 'Detalles del juego hardcodeado...',
      priceCents: s.priceCents,
      currency: s.currency,
      releaseDate: s.releaseDate,
      headerImageUrl: s.headerImageUrl,
    );
  }

  @override
  Future<List<CommunityPost>> listCommunityPosts(String gameId) async {
    final list = _postsByGameId[gameId] ?? const <CommunityPost>[];
    return List.unmodifiable(list);
  }

  @override
  Future<CommunityPost> createCommunityPost(
    String gameId,
    String content, {
    String? imageUrl,
  }) async {
    final post = CommunityPost(
      id: 'p-${DateTime.now().microsecondsSinceEpoch}',
      username: 'User',
      content: content,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
    final list = _postsByGameId.putIfAbsent(gameId, () => []);
    list.insert(0, post);
    return post;
  }

  @override
  Future<void> banUser(String userId) async {}

  @override
  Future<void> unbanUser(String userId) async {}

  @override
  Future<void> giftGame(String userId, String gameId) async {}

  @override
  Future<void> deletePost(String postId) async {}
}

class ArrayListGameRepository implements GameRepository {
  final List<GameSummary> _games = [
    GameSummary(
      id: '101',
      slug: 'minecraft',
      title: 'Minecraft',
      shortDescription: 'Sandbox',
      priceCents: 2699,
      currency: 'USD',
      headerImageUrl:
          'https://upload.wikimedia.org/wikipedia/en/5/51/Minecraft_cover.png',
      releaseDate: '2011-11-18',
    ),
    GameSummary(
      id: '102',
      slug: 'dota-2',
      title: 'Dota 2',
      shortDescription: 'MOBA',
      priceCents: 0,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/570/header.jpg',
      releaseDate: '2013-07-09',
    ),
    GameSummary(
      id: '103',
      slug: 'red-dead-redemption-2',
      title: 'Red Dead 2',
      shortDescription: 'Action',
      priceCents: 3999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1174180/header.jpg',
      releaseDate: '2019-12-05',
    ),
    GameSummary(
      id: '104',
      slug: 'gta-v',
      title: 'GTA V',
      shortDescription: 'Action',
      priceCents: 1999,
      currency: 'USD',
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/271590/header.jpg',
      releaseDate: '2015-04-14',
    ),
  ];

  @override
  Future<List<GameSummary>> listGames({String? q}) async {
    if (q == null || q.isEmpty) return _games;
    return _games
        .where((g) => g.title.toLowerCase().contains(q.toLowerCase()))
        .toList();
  }

  @override
  Future<GameDetails> getGameDetails(String slug) async {
    final game = _games.firstWhere((g) => g.slug == slug);
    return GameDetails(
      id: game.id,
      slug: game.slug,
      title: game.title,
      shortDescription: game.shortDescription,
      longDescription: 'This is an ArrayList description for ${game.title}.',
      priceCents: game.priceCents,
      currency: game.currency,
      headerImageUrl: game.headerImageUrl,
      releaseDate: game.releaseDate,
    );
  }

  @override
  Future<List<CommunityPost>> listCommunityPosts(String gameId) async => [];

  @override
  Future<CommunityPost> createCommunityPost(
    String gameId,
    String content, {
    String? imageUrl,
  }) async {
    return CommunityPost(
      id: '1',
      username: 'User',
      content: content,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> banUser(String userId) async {}

  @override
  Future<void> unbanUser(String userId) async {}

  @override
  Future<void> giftGame(String userId, String gameId) async {}

  @override
  Future<void> deletePost(String postId) async {}
}
