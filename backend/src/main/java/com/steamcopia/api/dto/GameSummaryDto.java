package com.steamcopia.api.dto;

import java.time.LocalDate;
import java.util.UUID;

public record GameSummaryDto(
    UUID id,
    String slug,
    String title,
    String shortDescription,
    int priceCents,
    String currency,
    LocalDate releaseDate,
    String headerImageUrl
) {}

