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