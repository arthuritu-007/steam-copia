CREATE TABLE app_user (
  id UUID PRIMARY KEY,
  email VARCHAR(320) NOT NULL UNIQUE,
  display_name VARCHAR(80) NOT NULL,
  password_hash VARCHAR(200) NOT NULL,
  role VARCHAR(20) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE game (
  id UUID PRIMARY KEY,
  slug VARCHAR(120) NOT NULL UNIQUE,
  title VARCHAR(160) NOT NULL,
  short_description VARCHAR(400) NOT NULL,
  long_description CLOB NOT NULL,
  price_cents INTEGER NOT NULL,
  currency VARCHAR(8) NOT NULL,
  release_date DATE,
  header_image_url VARCHAR(500),
  is_published BOOLEAN NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX game_published_idx ON game (is_published);

CREATE TABLE user_game (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  game_id UUID NOT NULL,
  acquired_at TIMESTAMP WITH TIME ZONE NOT NULL,
  playtime_minutes BIGINT NOT NULL,
  last_played_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT fk_user_game_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE,
  CONSTRAINT fk_user_game_game FOREIGN KEY (game_id) REFERENCES game(id),
  UNIQUE (user_id, game_id)
);

CREATE TABLE wishlist_item (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  game_id UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  CONSTRAINT fk_wishlist_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE,
  CONSTRAINT fk_wishlist_game FOREIGN KEY (game_id) REFERENCES game(id) ON DELETE CASCADE,
  UNIQUE (user_id, game_id)
);

CREATE TABLE purchase_order (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  status VARCHAR(20) NOT NULL,
  total_cents INTEGER NOT NULL,
  currency VARCHAR(8) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  paid_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES app_user(id)
);

CREATE TABLE purchase_order_item (
  id UUID PRIMARY KEY,
  order_id UUID NOT NULL,
  game_id UUID NOT NULL,
  unit_price_cents INTEGER NOT NULL,
  currency VARCHAR(8) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES purchase_order(id) ON DELETE CASCADE,
  CONSTRAINT fk_item_game FOREIGN KEY (game_id) REFERENCES game(id),
  UNIQUE (order_id, game_id)
);

