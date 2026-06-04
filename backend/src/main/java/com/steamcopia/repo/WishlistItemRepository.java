package com.steamcopia.repo;

import com.steamcopia.domain.WishlistItem;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface WishlistItemRepository extends JpaRepository<WishlistItem, UUID> {
  @Query("""
      select wi from WishlistItem wi
      join fetch wi.game g
      where wi.user.id = :userId
      order by wi.createdAt desc
      """)
  List<WishlistItem> findWishlist(@Param("userId") UUID userId);

  @Query("""
      select wi from WishlistItem wi
      where wi.user.id = :userId and wi.game.id = :gameId
      """)
  Optional<WishlistItem> findByUserAndGame(@Param("userId") UUID userId, @Param("gameId") UUID gameId);
}

