package com.steamcopia.repo;

import com.steamcopia.domain.Game;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface GameRepository extends JpaRepository<Game, UUID> {
  Optional<Game> findBySlug(String slug);

  List<Game> findAllByPublishedTrueOrderByCreatedAtDesc();

  @Query("""
      select g from Game g
      where g.published = true and (lower(g.title) like lower(concat('%', :q, '%')) or lower(g.slug) like lower(concat('%', :q, '%')))
      order by g.createdAt desc
      """)
  List<Game> searchPublished(@Param("q") String q);
}

