import 'api_client.dart';
import 'game_repository.dart';

enum RepositoryMode { api, hardcode, arraylist }

class RepositoryProvider {
  static RepositoryMode mode = RepositoryMode.api;
  static final ApiClient _api = ApiClient();

  static GameRepository get games {
    switch (mode) {
      case RepositoryMode.api:
        return ApiGameRepository(_api);
      case RepositoryMode.hardcode:
        return HardcodedGameRepository();
      case RepositoryMode.arraylist:
        return ArrayListGameRepository();
    }
  }

  static void setMode(RepositoryMode newMode) {
    mode = newMode;
  }
}
