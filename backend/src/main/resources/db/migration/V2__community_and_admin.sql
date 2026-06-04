ALTER TABLE app_user ADD COLUMN is_banned BOOLEAN NOT NULL DEFAULT FALSE;

CREATE TABLE community_post (
    id UUID PRIMARY KEY,
    game_id UUID NOT NULL REFERENCES game(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_community_post_game ON community_post(game_id);
CREATE INDEX idx_community_post_created ON community_post(created_at DESC);
