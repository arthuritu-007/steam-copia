import 'models.dart';
import 'api_client.dart';

abstract class GameRepository {
  Future<List<GameSummary>> listGames({String? q});
  Future<GameDetails> getGameDetails(String slug);
}

class ApiGameRepository implements GameRepository {
  final ApiClient _api;
  ApiGameRepository(this._api);

  @override
  Future<List<GameSummary>> listGames({String? q}) => _api.listGames(q: q);

  @override
  Future<GameDetails> getGameDetails(String slug) => _api.getGameDetails(slug);
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
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
      headerImageUrl: null,
      releaseDate: '2023-10-23',
      rating: 4.8,
      isNew: true,
      isTopSeller: true,
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
      longDescription: 'This is a hardcoded description for ${game.title}.',
      priceCents: game.priceCents,
      currency: game.currency,
      headerImageUrl: game.headerImageUrl,
      releaseDate: game.releaseDate,
    );
  }
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
}
