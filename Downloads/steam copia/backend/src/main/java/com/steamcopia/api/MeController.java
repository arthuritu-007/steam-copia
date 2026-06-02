package com.steamcopia.api;

import com.steamcopia.api.dto.UserDto;
import com.steamcopia.domain.AppUser;
import com.steamcopia.security.CurrentUser;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/me")
public class MeController {
  private final CurrentUser currentUser;

  public MeController(CurrentUser currentUser) {
    this.currentUser = currentUser;
  }

  @GetMapping
  public UserDto me() {
    AppUser u = currentUser.require();
    return new UserDto(u.getId(), u.getEmail(), u.getDisplayName(), u.getRole());
  }
}

