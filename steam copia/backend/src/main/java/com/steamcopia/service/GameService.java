package com.steamcopia.service;

import com.steamcopia.api.NotFoundException;
import com.steamcopia.api.dto.CreateGameRequest;
import com.steamcopia.domain.Game;
import com.steamcopia.repo.GameRepository;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class GameService {
  private final GameRepository games;

  public GameService(GameRepository games) {
    this.games = games;
  }

  @Transactional(readOnly = true)
  public List<Game> listPublished(String q) {
    if (q == null || q.isBlank()) {
      return games.findAllByPublishedTrueOrderByCreatedAtDesc();
    }
    return games.searchPublished(q.trim());
  }

  @Transactional(readOnly = true)
  public Game getPublishedBySlug(String slug) {
    Game g = games.findBySlug(slug).orElseThrow(() -> new NotFoundException("Juego no encontrado"));
    if (!g.isPublished()) {
      throw new NotFoundException("Juego no encontrado");
    }
    return g;
  }

  @Transactional(readOnly = true)
  public Game getById(UUID id) {
    return games.findById(id).orElseThrow(() -> new NotFoundException("Juego no encontrado"));
  }

  @Transactional
  public Game create(CreateGameRequest req) {
    Game g = new Game();
    g.setId(UUID.randomUUID());
    g.setSlug(req.slug().trim());
    g.setTitle(req.title().trim());
    g.setShortDescription(req.shortDescription().trim());
    g.setLongDescription(req.longDescription().trim());
    g.setPriceCents(req.priceCents());
    g.setCurrency(req.currency().trim().toUpperCase());
    g.setReleaseDate(req.releaseDate());
    g.setHeaderImageUrl(req.headerImageUrl());
    g.setPublished(req.published());
    g.setCreatedAt(Instant.now());
    return games.save(g);
  }
}

