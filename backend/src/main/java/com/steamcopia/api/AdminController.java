package com.steamcopia.api;

import com.steamcopia.domain.AppUser;
import com.steamcopia.domain.Game;
import com.steamcopia.domain.UserGame;
import com.steamcopia.repo.AppUserRepository;
import com.steamcopia.repo.CommunityPostRepository;
import com.steamcopia.repo.GameRepository;
import com.steamcopia.repo.UserGameRepository;
import java.time.Instant;
import java.util.UUID;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
public class AdminController {
  private final AppUserRepository users;
  private final GameRepository games;
  private final UserGameRepository userGames;
  private final CommunityPostRepository posts;

  public AdminController(
      AppUserRepository users,
      GameRepository games,
      UserGameRepository userGames,
      CommunityPostRepository posts
  ) {
    this.users = users;
    this.games = games;
    this.userGames = userGames;
    this.posts = posts;
  }

  @PostMapping("/users/{userId}/ban")
  public void banUser(@PathVariable UUID userId) {
    AppUser user = users.findById(userId).orElseThrow();
    user.setBanned(true);
    users.save(user);
  }

  @PostMapping("/users/{userId}/unban")
  public void unbanUser(@PathVariable UUID userId) {
    AppUser user = users.findById(userId).orElseThrow();
    user.setBanned(false);
    users.save(user);
  }

  @PostMapping("/users/{userId}/gift/{gameId}")
  public void giftGame(@PathVariable UUID userId, @PathVariable UUID gameId) {
    AppUser user = users.findById(userId).orElseThrow();
    Game game = games.findById(gameId).orElseThrow();
    
    if (!userGames.existsByUserIdAndGameId(userId, gameId)) {
      UserGame ug = new UserGame();
      ug.setId(UUID.randomUUID());
      ug.setUser(user);
      ug.setGame(game);
      ug.setAcquiredAt(Instant.now());
      ug.setPlaytimeMinutes(0L);
      userGames.save(ug);
    }
  }

  @DeleteMapping("/community/posts/{postId}")
  public void deletePost(@PathVariable UUID postId) {
    posts.deleteById(postId);
  }
}
