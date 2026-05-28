package com.steamcopia.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "user_game")
public class UserGame {
  @Id
  @Column(nullable = false)
  private UUID id;

  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "user_id", nullable = false)
  private AppUser user;

  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "game_id", nullable = false)
  private Game game;

  @Column(name = "acquired_at", nullable = false)
  private Instant acquiredAt;

  @Column(name = "playtime_minutes", nullable = false)
  private long playtimeMinutes;

  @Column(name = "last_played_at")
  private Instant lastPlayedAt;

  public UUID getId() {
    return id;
  }

  public void setId(UUID id) {
    this.id = id;
  }

  public AppUser getUser() {
    return user;
  }

  public void setUser(AppUser user) {
    this.user = user;
  }

  public Game getGame() {
    return game;
  }

  public void setGame(Game game) {
    this.game = game;
  }

  public Instant getAcquiredAt() {
    return acquiredAt;
  }

  public void setAcquiredAt(Instant acquiredAt) {
    this.acquiredAt = acquiredAt;
  }

  public long getPlaytimeMinutes() {
    return playtimeMinutes;
  }

  public void setPlaytimeMinutes(long playtimeMinutes) {
    this.playtimeMinutes = playtimeMinutes;
  }

  public Instant getLastPlayedAt() {
    return lastPlayedAt;
  }

  public void setLastPlayedAt(Instant lastPlayedAt) {
    this.lastPlayedAt = lastPlayedAt;
  }
}

