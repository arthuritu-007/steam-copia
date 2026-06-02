package com.steamcopia;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan
public class SteamCopiaApplication {
  public static void main(String[] args) {
    SpringApplication.run(SteamCopiaApplication.class, args);
  }
}

