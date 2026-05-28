class UserDto {
  final String id;
  final String email;
  final String displayName;
  final String role;

  UserDto({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      role: json['role'] as String,
    );
  }
}

class AuthResponse {
  final String accessToken;
  final UserDto user;

  AuthResponse({required this.accessToken, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class GameSummary {
  final String id;
  final String slug;
  final String title;
  final String shortDescription;
  final int priceCents;
  final String currency;
  final String? releaseDate;
  final String? headerImageUrl;

  GameSummary({
    required this.id,
    required this.slug,
    required this.title,
    required this.shortDescription,
    required this.priceCents,
    required this.currency,
    required this.releaseDate,
    required this.headerImageUrl,
  });

  factory GameSummary.fromJson(Map<String, dynamic> json) {
    return GameSummary(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String,
      priceCents: json['priceCents'] as int,
      currency: json['currency'] as String,
      releaseDate: json['releaseDate'] as String?,
      headerImageUrl: json['headerImageUrl'] as String?,
    );
  }
}

class GameDetails {
  final String id;
  final String slug;
  final String title;
  final String shortDescription;
  final String longDescription;
  final int priceCents;
  final String currency;
  final String? releaseDate;
  final String? headerImageUrl;

  GameDetails({
    required this.id,
    required this.slug,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
    required this.priceCents,
    required this.currency,
    required this.releaseDate,
    required this.headerImageUrl,
  });

  factory GameDetails.fromJson(Map<String, dynamic> json) {
    return GameDetails(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String,
      priceCents: json['priceCents'] as int,
      currency: json['currency'] as String,
      releaseDate: json['releaseDate'] as String?,
      headerImageUrl: json['headerImageUrl'] as String?,
    );
  }
}

class LibraryItem {
  final String gameId;
  final String slug;
  final String title;
  final String? headerImageUrl;
  final String acquiredAt;
  final int playtimeMinutes;
  final String? lastPlayedAt;

  LibraryItem({
    required this.gameId,
    required this.slug,
    required this.title,
    required this.headerImageUrl,
    required this.acquiredAt,
    required this.playtimeMinutes,
    required this.lastPlayedAt,
  });

  factory LibraryItem.fromJson(Map<String, dynamic> json) {
    return LibraryItem(
      gameId: json['gameId'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      headerImageUrl: json['headerImageUrl'] as String?,
      acquiredAt: json['acquiredAt'] as String,
      playtimeMinutes: (json['playtimeMinutes'] as num).toInt(),
      lastPlayedAt: json['lastPlayedAt'] as String?,
    );
  }
}
