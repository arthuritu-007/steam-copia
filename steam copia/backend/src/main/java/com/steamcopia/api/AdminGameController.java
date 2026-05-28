package com.steamcopia.api;

import com.steamcopia.api.dto.CreateGameRequest;
import com.steamcopia.api.dto.GameDetailsDto;
import com.steamcopia.domain.Game;
import com.steamcopia.service.GameService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/games")
public class AdminGameController {
  private final GameService games;

  public AdminGameController(GameService games) {
    this.games = games;
  }

  @PostMapping
  public GameDetailsDto create(@Valid @RequestBody CreateGameRequest req) {
    Game g = games.create(req);
    return new GameDetailsDto(
        g.getId(),
        g.getSlug(),
        g.getTitle(),
        g.getShortDescription(),
        g.getLongDescription(),
        g.getPriceCents(),
        g.getCurrency(),
        g.getReleaseDate(),
        g.getHeaderImageUrl()
    );
  }
}

