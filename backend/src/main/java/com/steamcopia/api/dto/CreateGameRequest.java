package com.steamcopia.api.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;

public record CreateGameRequest(
    @NotBlank @Size(min = 3, max = 80) String slug,
    @NotBlank @Size(min = 2, max = 120) String title,
    @NotBlank @Size(min = 2, max = 240) String shortDescription,
    @NotBlank @Size(min = 2, max = 10000) String longDescription,
    @Min(0) int priceCents,
    @NotBlank @Size(min = 3, max = 3) String currency,
    LocalDate releaseDate,
    String headerImageUrl,
    @NotNull Boolean published
) {}

