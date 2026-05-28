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
      headerImageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg',
      releaseDate: '2020-12-10',
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
