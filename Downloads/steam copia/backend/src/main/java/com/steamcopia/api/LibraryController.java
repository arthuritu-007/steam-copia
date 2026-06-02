package com.steamcopia.api;

import com.steamcopia.api.dto.LibraryItemDto;
import com.steamcopia.domain.UserGame;
import com.steamcopia.security.CurrentUser;
import com.steamcopia.service.LibraryService;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/library")
public class LibraryController {
  private final CurrentUser currentUser;
  private final LibraryService library;

  public LibraryController(CurrentUser currentUser, LibraryService library) {
    this.currentUser = currentUser;
    this.library = library;
  }

  @GetMapping
  public List<LibraryItemDto> list() {
    return library.list(currentUser.require().getId()).stream().map(LibraryController::toDto).toList();
  }

  private static LibraryItemDto toDto(UserGame ug) {
    return new LibraryItemDto(
        ug.getGame().getId(),
        ug.getGame().getSlug(),
        ug.getGame().getTitle(),
        ug.getGame().getHeaderImageUrl(),
        ug.getAcquiredAt(),
        ug.getPlaytimeMinutes(),
        ug.getLastPlayedAt()
    );
  }
}

