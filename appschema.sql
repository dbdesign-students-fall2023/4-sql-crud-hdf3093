CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    email TEXT NOT NULL,
    username TEXT NOT NULL,
    password TEXT NOT NULL,
);

CREATE TABLE posts (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    recipient_id INTEGER,
    content TEXT NOT NULL,
    is_message BOOLEAN,
    post_time DATETIME,
    visible INTEGER DEFAULT 1
);

.mode csv


CREATE TABLE temp_users (
    id INTEGER PRIMARY KEY,
    email TEXT,
    username TEXT,
    password TEXT
);

.import data/users.csv temp_users 

INSERT INTO users (email, username,password) SELECT email, username, password FROM temp_users;

DROP TABLE temp_users;

CREATE TABLE temp_posts (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    recipient_id INTEGER,
    content TEXT,
    is_message BOOLEAN,
    post_time DATETIME,
    visible INTEGER
);

.import data/posts.csv temp_posts 

INSERT INTO posts (user_id, content, is_message, post_time, visible) SELECT user_id, content, is_message, post_time, visible FROM temp_posts;

DROP TABLE temp_posts;