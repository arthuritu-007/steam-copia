package com.steamcopia.security;

import com.steamcopia.api.BadRequestException;
import com.steamcopia.domain.AppUser;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
public class CurrentUser {
  public AppUser require() {
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    if (auth == null || !(auth.getPrincipal() instanceof UserPrincipal principal)) {
      throw new BadRequestException("Sesión inválida");
    }
    return principal.getUser();
  }
}

