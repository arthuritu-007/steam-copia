package com.steamcopia.api.dto;

import java.time.Instant;

public record ApiError(String message, String code, Instant timestamp) {}

