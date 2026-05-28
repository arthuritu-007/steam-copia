package com.steamcopia.api.dto;

import com.steamcopia.domain.Role;
import java.util.UUID;

public record UserDto(UUID id, String email, String displayName, Role role) {}

