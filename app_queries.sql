-- new user
INSERT INTO users 
(id, email, username, password) 
VALUES (1001,'newuser@me.com', 'password', 'newusername');

-- new message from 1 user to another
INSERT INTO posts (user_id, recipient_id, content, is_message, post_time, visible)
VALUES (1, 2, 'Hello', 1, strftime('%m%d%Y %H:%M', 'now'), 1);


-- create a new story
INSERT INTO posts 
(user_id, recipient_id,
content, is_message,post_time,visible) 
VALUES (1,0,'My story',0,strftime('%m%d%Y %H:%M', 'now'),1);


-- 10 most recent visible in order of recency
SELECT content, (ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24)) AS hours_since_post
FROM posts
WHERE visible = 1
ORDER BY post_time DESC
LIMIT 10;



-- 10 most recent visible messages sent by 1 user to another
SELECT content, (ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24)) AS hours_since_post
FROM posts
WHERE visible = 1 AND is_message = true AND user_id = 1 AND recipient_id=2-- Change user_id as needed
ORDER BY post_time DESC
LIMIT 10;

-- invisible stories after 24 hrs
UPDATE posts
SET visible = 0
WHERE is_message = 0 AND (ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24)) > 24;

-- invisible messages/stories in recent order
SELECT content 
FROM posts 
WHERE visible=0 
ORDER BY post_time DESC;


-- number of posts by each user
SELECT user_id, COUNT(*) 
FROM posts 
GROUP BY user_id;

-- post text, email address of all posts and user who made them in last 24 hours
SELECT posts.content, users.email, users.username 
FROM posts 
INNER JOIN users 
    ON posts.user_id = users.id 
WHERE (ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24)) < 24;



-- emails of those who havent posted yet
SELECT users.email 
FROM users 
LEFT JOIN posts 
    ON users.id = posts.user_id 
WHERE posts.id IS NULL;

