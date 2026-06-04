package com.steamcopia.service;

import com.steamcopia.api.NotFoundException;
import com.steamcopia.domain.AppUser;
import com.steamcopia.domain.Game;
import com.steamcopia.domain.WishlistItem;
import com.steamcopia.repo.GameRepository;
import com.steamcopia.repo.WishlistItemRepository;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class WishlistService {
  private final WishlistItemRepository wishlist;
  private final GameRepository games;

  public WishlistService(WishlistItemRepository wishlist, GameRepository games) {
    this.wishlist = wishlist;
    this.games = games;
  }

  @Transactional(readOnly = true)
  public List<WishlistItem> list(UUID userId) {
    return wishlist.findWishlist(userId);
  }

  @Transactional
  public void add(AppUser user, UUID gameId) {
    Game g = games.findById(gameId).orElseThrow(() -> new NotFoundException("Juego no encontrado"));
    if (!g.isPublished()) {
      throw new NotFoundException("Juego no encontrado");
    }
    if (wishlist.findByUserAndGame(user.getId(), gameId).isPresent()) {
      return;
    }
    WishlistItem wi = new WishlistItem();
    wi.setId(UUID.randomUUID());
    wi.setUser(user);
    wi.setGame(g);
    wi.setCreatedAt(Instant.now());
    wishlist.save(wi);
  }

  @Transactional
  public void remove(UUID userId, UUID gameId) {
    wishlist.findByUserAndGame(userId, gameId).ifPresent(wishlist::delete);
  }
}

