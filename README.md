# SQL CRUD

## Part 1: Restaurant Finder

### Tables

```sql
CREATE TABLE restaurants (
    id INTEGER PRIMARY KEY,
    name TEXT,
    category TEXT,
    price_tier TEXT,
    neighborhood TEXT,
    opening_hours TIME,
    avg_rating REAL,
    good_for_kids BOOLEAN
);


CREATE TABLE reviews (
    review_id INTEGER PRIMARY KEY,
    restaurant_id INTEGER,
    user_name TEXT,
    rating INTEGER,
    comment TEXT,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (id)
);

```
### Mock Data

[Mock Data](data/restaurants.csv)

```sql
.mode csv

CREATE TABLE temp_table (
    id INTEGER PRIMARY KEY,
    name TEXT,
    category TEXT,
    price_tier TEXT,
    neighborhood TEXT,
    opening_hours TIME,
    avg_rating INTEGER,
    good_for_kids BOOLEAN NOT NULL
);

.import data/restaurants.csv temp_table

INSERT INTO restaurants SELECT * FROM temp_table;

DROP TABLE temp_table;

```

### Queries

1. Find all cheap restaurants in a particular neighborhood (pick any neighborhood as an example).
```sql
SELECT * FROM restaurants
WHERE price_tier = 'Cheap' AND neighborhood = 'Brooklyn';
```

2. Find all restaurants in a particular genre (pick any genre as an example) with 3 stars or more, ordered by the number of stars in descending order.
```sql
SELECT * FROM restaurants
WHERE category = 'Japanese' AND average_rating >= 3
ORDER BY average_rating DESC;
```

3. Find all restaurants that are open now.
```sql
SELECT name
FROM restaurants 
WHERE opening_hours>=strftime('%H:%M', 'now') 
    AND strftime('%H:%M', 'now')>='11:00';
```


4. Leave a review for a restaurant (pick any restaurant as an example).
```sql

INSERT INTO reviews (restaurant_id, user_name, rating, comment)
VALUES (222, 'Hannah Banana', 4, 'Amazing service! ごちそうさまでした');
```

5. Delete all restaurants that are not good for kids.
```sql

DELETE FROM restaurants
WHERE good_for_kids = 'false';
```

6. Find the number of restaurants in each NYC neighborhood.
```sql

SELECT neighborhood, COUNT(*) AS num_restaurants
FROM restaurants
GROUP BY neighborhood;
```

## Part 2: Social Media App

### Tables
```sql
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
```

### Mock Data
[Mock Posts](data/posts.csv)[Mock Users](data/users.csv)

```sql
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
```
### Queries

1. Register a new User.
```sql
INSERT INTO users 
(id, email, username, password) 
VALUES (1001,'newuser@me.com', 'password', 'newusername');
```

2. Create a new Message sent by a particular User to a particular User (pick any two Users for example).
```sql
INSERT INTO posts (user_id, recipient_id, content, is_message, post_time, visible)
VALUES (1, 2, 'Hello', 1, strftime('%m%d%Y %H:%M', 'now'), 1);
```
3. Create a new Story by a particular User (pick any User for example).
```sql
INSERT INTO posts 
(user_id, recipient_id,
content, is_message,post_time,visible) 
VALUES (1,0,'My story',0,strftime('%m%d%Y %H:%M', 'now'),1);
```
4. Show the 10 most recent visible Messages and Stories, in order of recency.
```sql
SELECT content, (ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24)) AS hours_since_post
FROM posts
WHERE visible = 1
ORDER BY post_time DESC
LIMIT 10;

```
5. Show the 10 most recent visible Messages sent by a particular User to a particular User (pick any two Users for example), in order of recency.
```sql
SELECT content, (ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24)) AS hours_since_post
FROM posts
WHERE visible = 1 AND is_message = true AND user_id = 1 AND recipient_id=2-- Change user_id as needed
ORDER BY post_time DESC
LIMIT 10;
```
6. Make all Stories that are more than 24 hours old invisible.
```sql
UPDATE posts
SET visible = 0
WHERE is_message = 0 AND (ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24)) > 24;
```
7. Show all invisible Messages and Stories, in order of recency.
```sql
SELECT content 
FROM posts 
WHERE visible=0 
ORDER BY post_time DESC;
```
8. Show the number of posts by each User.
```sql
SELECT user_id, COUNT(*) 
FROM posts 
GROUP BY user_id;
```
9. Show the post text and email address of all posts and the User who made them within the last 24 hours.
```sql
SELECT posts.content, users.email, users.username 
FROM posts 
INNER JOIN users 
    ON posts.user_id = users.id 
WHERE (ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24)) < 24;
```
10. Show the email addresses of all Users who have not posted anything yet.
```sql
SELECT users.email 
FROM users 
LEFT JOIN posts 
    ON users.id = posts.user_id 
WHERE posts.id IS NULL;
```



