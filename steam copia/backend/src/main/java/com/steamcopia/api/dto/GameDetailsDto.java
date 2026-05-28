package com.steamcopia.api.dto;

import java.time.LocalDate;
import java.util.UUID;

public record GameDetailsDto(
    UUID id,
    String slug,
    String title,
    String shortDescription,
    String longDescription,
    int priceCents,
    String currency,
    LocalDate releaseDate,
    String headerImageUrl
) {}

