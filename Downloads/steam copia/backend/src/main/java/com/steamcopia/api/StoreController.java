package com.steamcopia.api;

import com.steamcopia.api.dto.GameDetailsDto;
import com.steamcopia.api.dto.GameSummaryDto;
import com.steamcopia.domain.Game;
import com.steamcopia.service.GameService;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/store")
public class StoreController {
  private final GameService games;

  public StoreController(GameService games) {
    this.games = games;
  }

  @GetMapping("/games")
  public List<GameSummaryDto> list(@RequestParam(required = false) String q) {
    return games.listPublished(q).stream().map(StoreController::toSummary).toList();
  }

  @GetMapping("/games/{slug}")
  public GameDetailsDto details(@PathVariable String slug) {
    Game g = games.getPublishedBySlug(slug);
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

  private static GameSummaryDto toSummary(Game g) {
    return new GameSummaryDto(
        g.getId(),
        g.getSlug(),
        g.getTitle(),
        g.getShortDescription(),
        g.getPriceCents(),
        g.getCurrency(),
        g.getReleaseDate(),
        g.getHeaderImageUrl()
    );
  }
}

