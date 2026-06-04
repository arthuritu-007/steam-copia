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
      // Game 1: Elden Ring
      Game g1 = new Game();
      g1.setId(UUID.randomUUID());
      g1.setSlug("elden-ring");
      g1.setTitle("ELDEN RING");
      g1.setShortDescription("Levántate, Sinluz, y déjate guiar por la gracia para esgrimir el poder del Círculo de Elden.");
      g1.setLongDescription("ELDEN RING es un juego de acción y rol de temática fantástica desarrollado por FromSoftware Inc. y producido por Bandai Namco Entertainment Inc. Ambientado en un mundo lleno de misterios y peligros, es el juego más grande de FromSoftware hasta la fecha. Explora las Tierras Intermedias, un nuevo mundo de fantasía ideado por Hidetaka Miyazaki y George R. R. George R. Martin.");
      g1.setPriceCents(5999);
      g1.setCurrency("USD");
      g1.setPublished(true);
      g1.setCreatedAt(Instant.now());
      games.save(g1);

      // Game 2: Cyberpunk 2077
      Game g2 = new Game();
      g2.setId(UUID.randomUUID());
      g2.setSlug("cyberpunk-2077");
      g2.setTitle("Cyberpunk 2077");
      g2.setShortDescription("Un RPG de aventura y acción de mundo abierto ambientado en la megalópolis de Night City.");
      g2.setLongDescription("Cyberpunk 2077 es un RPG de aventura y acción de mundo abierto ambientado en la megalópolis de Night City, donde encarnarás a un mercenario cyberpunk envuelto en una lucha a vida o muerte por la supervivencia. Mejorado y con contenido nuevo y gratuito, personaliza a tu personaje y tu estilo de juego a medida que aceptas trabajos, te forjas una reputación y desbloqueas mejoras.");
      g2.setPriceCents(4999);
      g2.setCurrency("USD");
      g2.setPublished(true);
      g2.setCreatedAt(Instant.now());
      games.save(g2);

      // Game 3: Stardew Valley
      Game g3 = new Game();
      g3.setId(UUID.randomUUID());
      g3.setSlug("stardew-valley");
      g3.setTitle("Stardew Valley");
      g3.setShortDescription("Has heredado la vieja parcela agrícola de tu abuelo en Stardew Valley.");
      g3.setLongDescription("Stardew Valley es un RPG de vida campestre. ¡Has heredado la vieja parcela agrícola de tu abuelo en Stardew Valley! Decidido a comenzar una nueva vida con unas herramientas de segunda mano y unas pocas monedas, te dispones a vivir de la tierra y a convertir esos campos descuidados en un hogar próspero. No será fácil.");
      g3.setPriceCents(1499);
      g3.setCurrency("USD");
      g3.setPublished(true);
      g3.setCreatedAt(Instant.now());
      games.save(g3);
    }
  }
}

