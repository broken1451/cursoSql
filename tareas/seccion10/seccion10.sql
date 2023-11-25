[10:40, 21/11/2023] Adrian Bravo: https://medium.com/coding-blocks/creating-user-database-and-adding-access-on-postgresql-8bfcd2f4a91e

og_image - la imagen q sale
[10:41, 21/11/2023] Adrian Bravo: opne graph image


slug - https://medium.com/coding-blocks/creating-user-database-and-adding-access-on-postgresql-8bfcd2f4a91e - creating-user-database-and-adding-access-on-postgresql-8bfcd2f4a91e


Queries (Common Table Expressions)- es basicamente una forma  de  hacer querys recursivos a una misma tabla

diagrama con  https://dbdiagram.io

Table users {
  user_id integer [pk, increment] 
  username varchar [not null, unique]
  email varchar [not null, unique]
  password varchar [not null]
  name varchar [not null]
  role varchar [not null]
  gender varchar(10) [not null]
  avatar varchar

  created_at timestamp [default: 'now()']

  // indexes {
  //   (username)[unique]
  // }
}

Table posts {
  post_id integer [pk, increment]
  title varchar(200) [default: '']
  body text [default: '']
  og_image varchar
  slug varchar [not null, unique]
  published boolean

  created_by integer
}

Table claps {
  clap_id integer [pk, increment]
  post_id integer
  user_id integer
  counter integer [default: 0]

  created_at timestamp

  indexes {
    (post_id, user_id)[unique]
    (post_id)
  }
}


Table comments {
  comment_id integer [pk, increment]
  post_id integer
  user_id increment
  content text
  created_at timestamp
  visible boolean

  comment_parent_id integer

  indexes {
    (post_id)
    (visible)
  }
}


Table user_lists {
  user_list_id integer [pk, increment]
  user_id integer
  title varchar(100)

  indexes {
    (user_id, title)[unique]
    (user_id)
  }
}

Table user_list_entry {
  user_list_entry integer [pk, increment]
  user_list_id integer
  post_id integer
}

Ref: "users"."user_id" < "posts"."created_by"

Ref: "posts"."post_id" < "claps"."post_id"

Ref: "users"."user_id" < "claps"."user_id"

Ref: "posts"."post_id" < "comments"."comment_id"

Ref: "users"."user_id" < "comments"."user_id"

Ref: "comments"."comment_id" < "comments"."comment_parent_id"

Ref: "users"."user_id" < "user_lists"."user_id"

Ref: "user_lists"."user_list_id" < "user_list_entry"."user_list_id"

Ref: "posts"."post_id" < "user_list_entry"."post_id"


CREATE TABLE relations."users" (
  "user_id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "name" varchar NOT NULL,
  "username" varchar UNIQUE NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "password" varchar NOT NULL,
  "role" varchar NOT NULL,
  "gender" varchar NOT NULL,
  "avatar" varchar,
  "created_at" timestamp DEFAULT 'now()'
);

CREATE TABLE relations."post" (
  "created_by" integer,
  "post_id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "title" varchar DEFAULT '',
  "body" text DEFAULT '',
  "og_image" varchar,
  "slug" varchar UNIQUE NOT NULL,
  "published" boolean,
  "created_at" timestamp DEFAULT 'now()'
);

CREATE TABLE relations."claps" (
  "clap_id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "post_id" integer,
  "user_id" integer,
  "counter_clap" integer DEFAULT 0,
  "created_at" timestamp
);

CREATE TABLE relations."comments" (
  "comments_id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "post_id" integer,
  "user_id" integer,
  "content" text,
  "visible" boolean,
  "created_at" timestamp,
  "comments_parent_id" integer
);

CREATE TABLE relations."user_list" (
  "user_list_id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" integer,
  "title" varchar
);

CREATE TABLE relations."user_list_entry" (
  "user_list_entry_id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_list_id" integer,
  "post_id" integer
);

CREATE UNIQUE INDEX ON relations."claps" ("post_id", "user_id");

CREATE INDEX ON relations."claps" ("post_id");

CREATE INDEX ON relations."comments" ("post_id");

CREATE INDEX ON relations."comments" ("visible");

CREATE UNIQUE INDEX ON relations."user_list" ("user_id", "title");

CREATE INDEX ON relations."user_list" ("user_id");

ALTER TABLE relations."post" ADD FOREIGN KEY ("created_by") REFERENCES relations."users" ("user_id");

ALTER TABLE relations."claps" ADD FOREIGN KEY ("post_id") REFERENCES relations."post" ("post_id");

ALTER TABLE relations."claps" ADD FOREIGN KEY ("user_id") REFERENCES relations."users" ("user_id");

ALTER TABLE relations."comments" ADD FOREIGN KEY ("comments_id") REFERENCES relations."post" ("post_id");

ALTER TABLE relations."comments" ADD FOREIGN KEY ("user_id") REFERENCES relations."users" ("user_id");

ALTER TABLE relations."comments" ADD FOREIGN KEY ("comments_parent_id") REFERENCES relations."comments" ("comments_id");

ALTER TABLE relations."user_list" ADD FOREIGN KEY ("user_id") REFERENCES relations."users" ("user_id");

ALTER TABLE relations."user_list_entry" ADD FOREIGN KEY ("user_list_id") REFERENCES relations."user_list" ("user_list_id");

ALTER TABLE relations."user_list_entry" ADD FOREIGN KEY ("post_id") REFERENCES relations."post" ("post_id");


SELECT * FROM pg_extension;
DROP table countries cascade;
DROP table users cascade;