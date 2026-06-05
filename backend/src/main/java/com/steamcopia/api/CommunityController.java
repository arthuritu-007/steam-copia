package com.steamcopia.api;

import com.steamcopia.api.dto.CommunityPostDto;
import com.steamcopia.domain.AppUser;
import com.steamcopia.domain.CommunityPost;
import com.steamcopia.domain.Game;
import com.steamcopia.repo.CommunityPostRepository;
import com.steamcopia.repo.GameRepository;
import com.steamcopia.security.CurrentUser;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/community")
public class CommunityController {
  private final CommunityPostRepository posts;
  private final GameRepository games;
  private final CurrentUser currentUser;

  public CommunityController(CommunityPostRepository posts, GameRepository games, CurrentUser currentUser) {
    this.posts = posts;
    this.games = games;
    this.currentUser = currentUser;
  }

  @GetMapping("/{gameId}")
  public List<CommunityPostDto> getPosts(@PathVariable UUID gameId) {
    return posts.findByGameIdOrderByCreatedAtDesc(gameId).stream()
        .map(p -> new CommunityPostDto(
            p.getId(),
            p.getUser().getDisplayName(),
            p.getContent(),
            p.getCreatedAt()
        ))
        .toList();
  }

  @PostMapping("/{gameId}")
  public CommunityPostDto createPost(
      @PathVariable UUID gameId,
      @RequestBody String content
  ) {
    Game game = games.findById(gameId).orElseThrow();
    AppUser user = currentUser.require();
    
    if (user.isBanned()) {
      throw new RuntimeException("Usuario baneado");
    }

    CommunityPost post = new CommunityPost();
    post.setId(UUID.randomUUID());
    post.setGame(game);
    post.setUser(user);
    post.setContent(content);
    post.setCreatedAt(Instant.now());
    
    posts.save(post);
    
    return new CommunityPostDto(
        post.getId(),
        user.getDisplayName(),
        post.getContent(),
        post.getCreatedAt()
    );
  }
}
