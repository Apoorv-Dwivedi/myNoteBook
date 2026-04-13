-- ── USERS ──────────────────────────────────────────────────────────────────
CREATE TABLE users (
                       id            BIGSERIAL PRIMARY KEY,
                       email         VARCHAR(255) UNIQUE,
                       phone_number  VARCHAR(20)  UNIQUE,
                       password_hash VARCHAR(255) NOT NULL,
                       status        VARCHAR(20)  NOT NULL DEFAULT 'PENDING',
                       role          VARCHAR(20)  NOT NULL DEFAULT 'USER',
                       created_at    TIMESTAMP    NOT NULL DEFAULT NOW(),
                       updated_at    TIMESTAMP    NOT NULL DEFAULT NOW(),

    -- At least one of email or phone must be provided
                       CONSTRAINT chk_user_contact CHECK (
                           email IS NOT NULL OR phone_number IS NOT NULL
                           )
);

CREATE INDEX idx_users_email        ON users(email)        WHERE email IS NOT NULL;
CREATE INDEX idx_users_phone_number ON users(phone_number) WHERE phone_number IS NOT NULL;

-- ── NOTEBOOKS ───────────────────────────────────────────────────────────────
CREATE TABLE notebooks (
                           id          BIGSERIAL PRIMARY KEY,
                           name        VARCHAR(100) NOT NULL,
                           description VARCHAR(255),
                           owner_id    BIGINT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                           created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
                           updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_notebooks_owner_id ON notebooks(owner_id);

-- ── NOTES ───────────────────────────────────────────────────────────────────
CREATE TABLE notes (
                       id          BIGSERIAL PRIMARY KEY,
                       title       VARCHAR(200) NOT NULL,
                       content     TEXT,
                       notebook_id BIGINT    NOT NULL REFERENCES notebooks(id) ON DELETE CASCADE,
                       owner_id    BIGINT    NOT NULL REFERENCES users(id)     ON DELETE CASCADE,
                       created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
                       updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_notes_notebook_id ON notes(notebook_id);
CREATE INDEX idx_notes_owner_id    ON notes(owner_id);

-- ── OTP VERIFICATIONS ────────────────────────────────────────────────────────
CREATE TABLE otp_verifications (
                                   id              BIGSERIAL PRIMARY KEY,
                                   user_id         BIGINT      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                                   code            VARCHAR(10) NOT NULL,
                                   delivery_method VARCHAR(10) NOT NULL,
                                   expires_at      TIMESTAMP   NOT NULL,
                                   used            BOOLEAN     NOT NULL DEFAULT FALSE,
                                   created_at      TIMESTAMP   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_otp_user_id ON otp_verifications(user_id);

-- ── REFRESH TOKENS ───────────────────────────────────────────────────────────
CREATE TABLE refresh_tokens (
                                id         BIGSERIAL PRIMARY KEY,
                                user_id    BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                                token      VARCHAR(512) NOT NULL UNIQUE,
                                expires_at TIMESTAMP    NOT NULL,
                                revoked    BOOLEAN      NOT NULL DEFAULT FALSE,
                                created_at TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token   ON refresh_tokens(token);