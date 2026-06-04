package com.steamcopia.security;

import com.steamcopia.config.AppProperties;
import com.steamcopia.domain.AppUser;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import javax.crypto.SecretKey;
import org.springframework.stereotype.Service;

@Service
public class JwtService {
  private final AppProperties props;
  private final SecretKey key;

  public JwtService(AppProperties props) {
    this.props = props;
    if (props.jwt().secret() == null || props.jwt().secret().length() < 32) {
      throw new IllegalStateException("JWT_SECRET debe tener al menos 32 caracteres");
    }
    this.key = Keys.hmacShaKeyFor(props.jwt().secret().getBytes(StandardCharsets.UTF_8));
  }

  public String issueAccessToken(AppUser user) {
    Instant now = Instant.now();
    Instant exp = now.plus(props.jwt().accessTokenMinutes(), ChronoUnit.MINUTES);
    return Jwts.builder()
        .issuer(props.jwt().issuer())
        .subject(user.getId().toString())
        .issuedAt(Date.from(now))
        .expiration(Date.from(exp))
        .claim("email", user.getEmail())
        .claim("role", user.getRole().name())
        .signWith(key)
        .compact();
  }

  public Jws<Claims> parseAndValidate(String token) {
    return Jwts.parser()
        .verifyWith(key)
        .requireIssuer(props.jwt().issuer())
        .build()
        .parseSignedClaims(token);
  }
}

