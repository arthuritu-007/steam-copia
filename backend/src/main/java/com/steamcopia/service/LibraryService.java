package com.steamcopia.service;

import com.steamcopia.domain.UserGame;
import com.steamcopia.repo.UserGameRepository;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LibraryService {
  private final UserGameRepository userGames;

  public LibraryService(UserGameRepository userGames) {
    this.userGames = userGames;
  }

  @Transactional(readOnly = true)
  public List<UserGame> list(UUID userId) {
    return userGames.findLibrary(userId);
  }
}

