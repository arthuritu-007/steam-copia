package com.steamcopia.api;

import com.steamcopia.api.dto.PurchaseRequest;
import com.steamcopia.api.dto.PurchaseResponse;
import com.steamcopia.domain.PurchaseOrder;
import com.steamcopia.security.CurrentUser;
import com.steamcopia.service.PurchaseService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/purchase")
public class PurchaseController {
  private final CurrentUser currentUser;
  private final PurchaseService purchases;

  public PurchaseController(CurrentUser currentUser, PurchaseService purchases) {
    this.currentUser = currentUser;
    this.purchases = purchases;
  }

  @PostMapping
  public PurchaseResponse purchase(@Valid @RequestBody PurchaseRequest req) {
    PurchaseOrder o = purchases.purchase(currentUser.require(), req.gameIds());
    return new PurchaseResponse(o.getId(), o.getTotalCents(), o.getCurrency());
  }
}

