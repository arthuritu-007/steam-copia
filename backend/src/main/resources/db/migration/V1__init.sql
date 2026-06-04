CREATE TABLE app_user (
  id UUID PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  display_name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE game (
  id UUID PRIMARY KEY,
  slug TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  short_description TEXT NOT NULL,
  long_description TEXT NOT NULL,
  price_cents INTEGER NOT NULL,
  currency TEXT NOT NULL,
  release_date DATE,
  header_image_url TEXT,
  is_published BOOLEAN NOT NULL,
  created_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX game_published_idx ON game (is_published);

CREATE TABLE user_game (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
  game_id UUID NOT NULL REFERENCES game(id) ON DELETE RESTRICT,
  acquired_at TIMESTAMPTZ NOT NULL,
  playtime_minutes BIGINT NOT NULL,
  last_played_at TIMESTAMPTZ,
  UNIQUE (user_id, game_id)
);

CREATE TABLE wishlist_item (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
  game_id UUID NOT NULL REFERENCES game(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL,
  UNIQUE (user_id, game_id)
);

CREATE TABLE purchase_order (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
  status TEXT NOT NULL,
  total_cents INTEGER NOT NULL,
  currency TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  paid_at TIMESTAMPTZ
);

CREATE TABLE purchase_order_item (
  id UUID PRIMARY KEY,
  order_id UUID NOT NULL REFERENCES purchase_order(id) ON DELETE CASCADE,
  game_id UUID NOT NULL REFERENCES game(id) ON DELETE RESTRICT,
  unit_price_cents INTEGER NOT NULL,
  currency TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  UNIQUE (order_id, game_id)
);

