package com.steamcopia.service;

import com.steamcopia.api.BadRequestException;
import com.steamcopia.api.dto.AuthResponse;
import com.steamcopia.api.dto.LoginRequest;
import com.steamcopia.api.dto.RegisterRequest;
import com.steamcopia.api.dto.UserDto;
import com.steamcopia.domain.AppUser;
import com.steamcopia.domain.Role;
import com.steamcopia.repo.AppUserRepository;
import com.steamcopia.security.JwtService;
import java.time.Instant;
import java.util.UUID;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {
  private final AppUserRepository users;
  private final PasswordEncoder encoder;
  private final JwtService jwt;

  public AuthService(AppUserRepository users, PasswordEncoder encoder, JwtService jwt) {
    this.users = users;
    this.encoder = encoder;
    this.jwt = jwt;
  }

  @Transactional
  public AuthResponse register(RegisterRequest req) {
    String email = req.email().trim().toLowerCase();
    if (users.existsByEmailIgnoreCase(email)) {
      throw new BadRequestException("El email ya está registrado");
    }

    AppUser u = new AppUser();
    u.setId(UUID.randomUUID());
    u.setEmail(email);
    u.setDisplayName(req.displayName().trim());
    u.setPasswordHash(encoder.encode(req.password()));
    u.setRole(Role.USER);
    u.setCreatedAt(Instant.now());
    users.save(u);

    String token = jwt.issueAccessToken(u);
    return new AuthResponse(token, new UserDto(u.getId(), u.getEmail(), u.getDisplayName(), u.getRole()));
  }

  @Transactional(readOnly = true)
  public AuthResponse login(LoginRequest req) {
    AppUser u = users.findByEmailIgnoreCase(req.email().trim())
        .orElseThrow(() -> new BadRequestException("Credenciales inválidas"));
    if (!encoder.matches(req.password(), u.getPasswordHash())) {
      throw new BadRequestException("Credenciales inválidas");
    }
    String token = jwt.issueAccessToken(u);
    return new AuthResponse(token, new UserDto(u.getId(), u.getEmail(), u.getDisplayName(), u.getRole()));
  }
}

