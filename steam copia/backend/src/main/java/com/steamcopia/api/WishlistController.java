package com.steamcopia.api;

import com.steamcopia.api.dto.WishlistItemDto;
import com.steamcopia.domain.WishlistItem;
import com.steamcopia.security.CurrentUser;
import com.steamcopia.service.WishlistService;
import java.util.List;
import java.util.UUID;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/wishlist")
public class WishlistController {
  private final CurrentUser currentUser;
  private final WishlistService wishlist;

  public WishlistController(CurrentUser currentUser, WishlistService wishlist) {
    this.currentUser = currentUser;
    this.wishlist = wishlist;
  }

  @GetMapping
  public List<WishlistItemDto> list() {
    return wishlist.list(currentUser.require().getId()).stream().map(WishlistController::toDto).toList();
  }

  @PostMapping("/{gameId}")
  public void add(@PathVariable UUID gameId) {
    wishlist.add(currentUser.require(), gameId);
  }

  @DeleteMapping("/{gameId}")
  public void remove(@PathVariable UUID gameId) {
    wishlist.remove(currentUser.require().getId(), gameId);
  }

  private static WishlistItemDto toDto(WishlistItem wi) {
    return new WishlistItemDto(
        wi.getGame().getId(),
        wi.getGame().getSlug(),
        wi.getGame().getTitle(),
        wi.getGame().getHeaderImageUrl(),
        wi.getGame().getPriceCents(),
        wi.getGame().getCurrency(),
        wi.getCreatedAt()
    );
  }
}

