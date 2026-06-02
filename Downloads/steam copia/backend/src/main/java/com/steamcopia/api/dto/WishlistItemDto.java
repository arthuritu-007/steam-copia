package com.steamcopia.api.dto;

import java.time.Instant;
import java.util.UUID;

public record WishlistItemDto(
    UUID gameId,
    String slug,
    String title,
    String headerImageUrl,
    int priceCents,
    String currency,
    Instant addedAt
) {}

