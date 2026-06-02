package com.steamcopia.config;

import com.steamcopia.domain.AppUser;
import com.steamcopia.domain.Game;
import com.steamcopia.domain.Role;
import com.steamcopia.repo.AppUserRepository;
import com.steamcopia.repo.GameRepository;
import java.time.Instant;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class SeedRunner implements CommandLineRunner {
  private final boolean enabled;
  private final AppUserRepository users;
  private final GameRepository games;
  private final PasswordEncoder encoder;

  public SeedRunner(
      @Value("${APP_SEED:false}") boolean enabled,
      AppUserRepository users,
      GameRepository games,
      PasswordEncoder encoder
  ) {
    this.enabled = enabled;
    this.users = users;
    this.games = games;
    this.encoder = encoder;
  }

  @Override
  public void run(String... args) {
    if (!enabled) {
      return;
    }

    if (!users.existsByEmailIgnoreCase("admin@local")) {
      AppUser admin = new AppUser();
      admin.setId(UUID.randomUUID());
      admin.setEmail("admin@local");
      admin.setDisplayName("Admin");
      admin.setPasswordHash(encoder.encode("adminadmin"));
      admin.setRole(Role.ADMIN);
      admin.setCreatedAt(Instant.now());
      users.save(admin);
    }

    if (games.count() == 0) {
      Game g = new Game();
      g.setId(UUID.randomUUID());
      g.setSlug("half-life-copia");
      g.setTitle("Half-Life Copia");
      g.setShortDescription("Shooter clásico (demo de datos).");
      g.setLongDescription("Juego de ejemplo para poblar la tienda en desarrollo.");
      g.setPriceCents(999);
      g.setCurrency("USD");
      g.setReleaseDate(null);
      g.setHeaderImageUrl(null);
      g.setPublished(true);
      g.setCreatedAt(Instant.now());
      games.save(g);
    }
  }
}

