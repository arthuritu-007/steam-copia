package com.steamcopia.api.dto;

import java.time.Instant;
import java.util.UUID;

public record CommunityPostDto(
    UUID id,
    String username,
    String content,
    Instant createdAt
) {}
