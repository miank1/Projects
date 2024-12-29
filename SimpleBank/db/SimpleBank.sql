CREATE TABLE IF NOT EXISTS "Account" (
  "id" bigserial PRIMARY KEY,
  "owner" varchar NOT NULL,
  "balance" bigint NOT NULL,
  "currency" varchar NOT NULL,
  "created_at" timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "entries" (
  "id" bigserial PRIMARY KEY,
  "account_id" bigint,
  "amount" bigint NOT NULL,
  "created_at" timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "transfers" (
  "id" bigserial PRIMARY KEY,
  "from_account_id" bigint,
  "to_account_id" bigint,
  "amount" bigint NOT NULL,
  "created_at" timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS account_owner_idx ON "Account" ("owner");

CREATE INDEX IF NOT EXISTS entries_account_id_idx ON "entries" ("account_id");

CREATE INDEX IF NOT EXISTS transfers_from_account_id_idx ON "transfers" ("from_account_id");

CREATE INDEX IF NOT EXISTS transfers_to_account_id_idx ON "transfers" ("to_account_id");

CREATE INDEX IF NOT EXISTS transfers_from_to_account_id_idx ON "transfers" ("from_account_id", "to_account_id");

COMMENT ON COLUMN "entries"."amount" IS 'can be negative or positive';

COMMENT ON COLUMN "transfers"."amount" IS 'can be negative or positive';

ALTER TABLE "entries" 
  ADD CONSTRAINT entries_account_id_fk 
  FOREIGN KEY ("account_id") REFERENCES "Account" ("id");

ALTER TABLE "transfers" 
  ADD CONSTRAINT transfers_from_account_id_fk 
  FOREIGN KEY ("from_account_id") REFERENCES "Account" ("id");

ALTER TABLE "transfers" 
  ADD CONSTRAINT transfers_to_account_id_fk 
  FOREIGN KEY ("to_account_id") REFERENCES "Account" ("id");

DO $$ BEGIN
  CREATE TYPE "Currency" AS ENUM ('USD', 'EUR');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

