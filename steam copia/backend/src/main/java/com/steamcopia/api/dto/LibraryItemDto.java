package com.steamcopia.api.dto;

import java.time.Instant;
import java.util.UUID;

public record LibraryItemDto(
    UUID gameId,
    String slug,
    String title,
    String headerImageUrl,
    Instant acquiredAt,
    long playtimeMinutes,
    Instant lastPlayedAt
) {}

