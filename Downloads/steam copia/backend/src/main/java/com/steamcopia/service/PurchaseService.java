package com.steamcopia.service;

import com.steamcopia.api.BadRequestException;
import com.steamcopia.api.NotFoundException;
import com.steamcopia.domain.AppUser;
import com.steamcopia.domain.Game;
import com.steamcopia.domain.OrderStatus;
import com.steamcopia.domain.PurchaseOrder;
import com.steamcopia.domain.PurchaseOrderItem;
import com.steamcopia.domain.UserGame;
import com.steamcopia.repo.GameRepository;
import com.steamcopia.repo.PurchaseOrderItemRepository;
import com.steamcopia.repo.PurchaseOrderRepository;
import com.steamcopia.repo.UserGameRepository;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PurchaseService {
  private final GameRepository games;
  private final UserGameRepository userGames;
  private final PurchaseOrderRepository orders;
  private final PurchaseOrderItemRepository orderItems;

  public PurchaseService(
      GameRepository games,
      UserGameRepository userGames,
      PurchaseOrderRepository orders,
      PurchaseOrderItemRepository orderItems
  ) {
    this.games = games;
    this.userGames = userGames;
    this.orders = orders;
    this.orderItems = orderItems;
  }

  @Transactional
  public PurchaseOrder purchase(AppUser user, List<UUID> gameIds) {
    if (gameIds == null || gameIds.isEmpty()) {
      throw new BadRequestException("No hay juegos para comprar");
    }

    List<Game> toBuy = new ArrayList<>();
    for (UUID gameId : gameIds) {
      Game g = games.findById(gameId).orElseThrow(() -> new NotFoundException("Juego no encontrado"));
      if (!g.isPublished()) {
        throw new NotFoundException("Juego no encontrado");
      }
      if (userGames.findByUserAndGame(user.getId(), g.getId()).isPresent()) {
        throw new BadRequestException("Ya tienes uno de los juegos seleccionados");
      }
      toBuy.add(g);
    }

    String currency = toBuy.get(0).getCurrency();
    int total = 0;
    for (Game g : toBuy) {
      if (!currency.equals(g.getCurrency())) {
        throw new BadRequestException("No se pueden mezclar monedas en una compra");
      }
      total += g.getPriceCents();
    }

    Instant now = Instant.now();

    PurchaseOrder order = new PurchaseOrder();
    order.setId(UUID.randomUUID());
    order.setUser(user);
    order.setStatus(OrderStatus.PAID);
    order.setTotalCents(total);
    order.setCurrency(currency);
    order.setCreatedAt(now);
    order.setPaidAt(now);
    orders.save(order);

    for (Game g : toBuy) {
      PurchaseOrderItem item = new PurchaseOrderItem();
      item.setId(UUID.randomUUID());
      item.setOrder(order);
      item.setGame(g);
      item.setUnitPriceCents(g.getPriceCents());
      item.setCurrency(g.getCurrency());
      item.setCreatedAt(now);
      orderItems.save(item);

      UserGame ug = new UserGame();
      ug.setId(UUID.randomUUID());
      ug.setUser(user);
      ug.setGame(g);
      ug.setAcquiredAt(now);
      ug.setPlaytimeMinutes(0);
      ug.setLastPlayedAt(null);
      userGames.save(ug);
    }

    return order;
  }
}

