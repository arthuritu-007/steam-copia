package com.steamcopia.api.dto;

import java.util.UUID;

public record PurchaseResponse(UUID orderId, int totalCents, String currency) {}

