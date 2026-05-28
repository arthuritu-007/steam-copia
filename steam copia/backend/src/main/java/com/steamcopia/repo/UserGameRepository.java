package com.steamcopia.repo;

import com.steamcopia.domain.UserGame;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserGameRepository extends JpaRepository<UserGame, UUID> {
  @Query("""
      select ug from UserGame ug
      join fetch ug.game g
      where ug.user.id = :userId
      order by ug.acquiredAt desc
      """)
  List<UserGame> findLibrary(@Param("userId") UUID userId);

  @Query("""
      select ug from UserGame ug
      where ug.user.id = :userId and ug.game.id = :gameId
      """)
  Optional<UserGame> findByUserAndGame(@Param("userId") UUID userId, @Param("gameId") UUID gameId);
}

