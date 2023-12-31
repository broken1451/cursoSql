CREATE TYPE "product_status" AS ENUM (
    'in_stock',
    'out_of_stock',
    'running_low'
);

CREATE TABLE
    "product" (
        "product_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
        "serial" varchar,
        "name" varchar(200),
        "merchant" varchar,
        "price" float(8, 2),
        "status" product_status,
        "stock" int,
        "create_at" timestamp DEFAULT 'now()'
    );

-------
-- 2 --
CREATE TABLE
    "user" (
        "user_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
        "name" varchar,
        "email" varchar UNIQUE,
        "username" varchar,
        "bio" varchar,
        "profession" varchar,
        "social_red" array,
        "web_site" varchar,
        "country" varchar,
        "birth_day" date,
        "photo" varchar,
        "create_at" timestamp DEFAULT 'now()'
    );

CREATE TABLE
    "tweet" (
        "tweet_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
        "user_id" int,
        "post" varchar DEFAULT '',
        "post_reply" int,
        "coments" varchar,
        "repost" int,
        "likes" int,
        "reproductions" float,
        "marker" boolean,
        "shared" varchar,
        "tweet_parent_id" integer,
        "create_at" timestamp DEFAULT 'now()'
    );

CREATE TABLE
    "following" (
        "followers_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
        "user_id" int,
        "name" varchar,
        "username" varchar,
        "profession" varchar,
        "flollow" boolean,
        "create_at" timestamp DEFAULT 'now()'
    );

CREATE TABLE
    "followers" (
        "followers_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
        "user_id" int,
        "name" varchar,
        "username" varchar,
        "profession" varchar,
        "flollow" boolean,
        "create_at" timestamp DEFAULT 'now()'
    );

ALTER TABLE "tweet"
ADD
    FOREIGN KEY ("tweet_parent_id") REFERENCES "tweet" ("tweet_id");

ALTER TABLE "user"
ADD
    FOREIGN KEY ("user_id") REFERENCES "tweet" ("user_id");

ALTER TABLE "following"
ADD
    FOREIGN KEY ("followers_id") REFERENCES "user" ("user_id");

ALTER TABLE "followers"
ADD
    FOREIGN KEY ("followers_id") REFERENCES "user" ("user_id");