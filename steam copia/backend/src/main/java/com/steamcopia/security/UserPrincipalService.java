package com.steamcopia.security;

import com.steamcopia.repo.AppUserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserPrincipalService implements UserDetailsService {
  private final AppUserRepository users;

  public UserPrincipalService(AppUserRepository users) {
    this.users = users;
  }

  @Override
  public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
    return users.findByEmailIgnoreCase(username)
        .map(UserPrincipal::new)
        .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado"));
  }
}

