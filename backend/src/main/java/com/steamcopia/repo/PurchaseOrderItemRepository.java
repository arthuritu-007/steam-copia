package com.steamcopia.repo;

import com.steamcopia.domain.PurchaseOrderItem;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PurchaseOrderItemRepository extends JpaRepository<PurchaseOrderItem, UUID> {
  @Query("""
      select i from PurchaseOrderItem i
      join fetch i.game g
      where i.order.id = :orderId
      """)
  List<PurchaseOrderItem> findItems(@Param("orderId") UUID orderId);
}

