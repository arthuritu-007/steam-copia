package com.steamcopia.repo;

import com.steamcopia.domain.PurchaseOrder;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PurchaseOrderRepository extends JpaRepository<PurchaseOrder, UUID> {
  @Query("""
      select o from PurchaseOrder o
      where o.user.id = :userId
      order by o.createdAt desc
      """)
  List<PurchaseOrder> findForUser(@Param("userId") UUID userId);
}

