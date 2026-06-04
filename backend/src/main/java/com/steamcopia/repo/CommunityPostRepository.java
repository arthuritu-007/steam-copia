package com.steamcopia.repo;

import com.steamcopia.domain.CommunityPost;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommunityPostRepository extends JpaRepository<CommunityPost, UUID> {
  List<CommunityPost> findByGameIdOrderByCreatedAtDesc(UUID gameId);
}
