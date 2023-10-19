SELECT * FROM restaurants
WHERE price_tier = 'Cheap' AND neighborhood = 'Brooklyn';

SELECT * FROM restaurants
WHERE category = 'Japanese' AND average_rating >= 3
ORDER BY average_rating DESC;
SELECT * FROM reviews WHERE restaurant_id = 222;


SELECT name
FROM restaurants 
WHERE opening_hours>=strftime('%H:%M', 'now') 
    AND strftime('%H:%M', 'now')>='11:00';

INSERT INTO reviews (restaurant_id, user_name, rating, comment)
VALUES (222, 'Hannah Banana', 4, 'Amazing service! ごちそうさまでした');

DELETE FROM restaurants
WHERE good_for_kids = 'false';

SELECT neighborhood, COUNT(*) AS num_restaurants
FROM restaurants
GROUP BY neighborhood;



