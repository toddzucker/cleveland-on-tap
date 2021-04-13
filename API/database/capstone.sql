USE master
GO

--drop database if it exists
IF DB_ID('final_capstone') IS NOT NULL
BEGIN
	ALTER DATABASE final_capstone SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE final_capstone;
END

CREATE DATABASE final_capstone
GO

USE final_capstone
GO

--create tables
CREATE TABLE users (
	user_id int IDENTITY(1,1) NOT NULL,
	username varchar(50) NOT NULL UNIQUE,
	password_hash varchar(200) NOT NULL,
	salt varchar(200) NOT NULL,
	user_role varchar(50) NOT NULL
	CONSTRAINT PK_user_id PRIMARY KEY (user_id)
	--we changed username to be unique, may be a redundant level of error checking but whatever
)

CREATE TABLE breweries (
	brewery_id int IDENTITY(1,1) NOT NULL,
	user_id int NOT NULL,
	brewery_name nvarchar(100) NOT NULL,
	history nvarchar (2000) NOT NULL,
	street_address nvarchar(400) NOT NULL,
	phone nvarchar(15) NOT NULL,
	city nvarchar(200) NOT NULL,
	zip_code nvarchar (15) NOT NULL,
	is_active bit NOT NULL,
	CONSTRAINT PK_brewery_id PRIMARY KEY (brewery_id),
	CONSTRAINT FK_breweries_users FOREIGN KEY (user_id) REFERENCES users(user_id),
)


CREATE TABLE hours (
	hours_id int IDENTITY (1,1) NOT NULL,
	brewery_id int NOT NULL,
	day_of_week int NOT NULL,
	open_hour int NOT NULL,
	open_minute int NOT NULL,
	open_am_pm nvarchar(2) NOT NULL,
	close_hour int NOT NULL,
	close_minute int NOT NULL,
	close_am_pm nvarchar(2) NOT NULL,
	is_closed bit NOT NULL,
	CONSTRAINT PK_hours_id PRIMARY KEY (hours_id),
	CONSTRAINT FK_hours_breweries FOREIGN KEY (brewery_id) REFERENCES breweries(brewery_id),
	CONSTRAINT CHK_day_of_week CHECK (day_of_week > 0 AND day_of_week <= 7),
	CONSTRAINT CHK_open_hours CHECK (open_hour >= 0 AND open_hour <= 12),
	CONSTRAINT CHK_close_hours CHECK (close_hour >= 0 AND close_hour <= 12),
	CONSTRAINT CHK_open_minute CHECK (open_minute >= 0 AND open_minute < 60),
	CONSTRAINT CHK_close_minute CHECK (close_minute >= 0 AND close_minute < 60)

--INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
--VALUES (3, '1', '0', '0', '0', '0', '0', '0','0');

)

CREATE TABLE brewery_images (
	image_id int IDENTITY (1,1),
	brewery_id int NOT NULL,
	image_url nvarchar(200) NOT NULL,
	CONSTRAINT PK_image_id PRIMARY KEY (image_id),
	CONSTRAINT FK_brewery_images_breweries FOREIGN KEY (brewery_id) REFERENCES breweries(brewery_id)
--INSERT INTO brewery images (brewery_id, image_url)
--VALUES (3, '');

)
-- Consider making abv a decimal datatype
CREATE TABLE beers (
	beer_id int IDENTITY (1, 1),
	brewery_id int NOT NULL,
	beer_name nvarchar(100) NOT NULL,
	description nvarchar(1000) NOT NULL,
	image_url nvarchar(200) NOT NULL,
	abv nvarchar(5) NOT NULL,
	beer_type nvarchar(50) NOT NULL,
	is_active bit NOT NULL
	CONSTRAINT PK_beer_id PRIMARY KEY (beer_id),
	CONSTRAINT FK_beers_breweries FOREIGN KEY (brewery_id) REFERENCES breweries(brewery_id)


)

CREATE TABLE reviews (
	beer_review_id int IDENTITY (1, 1),
	beer_id int NOT NULL,
	user_id int NOT NULL,
	rating int NOT NULL,
	review_title nvarchar(100) NOT NULL,
	review_body nvarchar(1000) NOT NULL,
	date_of_review datetime NOT NULL,
	CONSTRAINT PK_beer_review_id PRIMARY KEY (beer_review_id),
	CONSTRAINT FK_reviews_beers FOREIGN KEY (beer_id) REFERENCES beers(beer_id),
	CONSTRAINT FK_reviews_users FOREIGN KEY (user_id) REFERENCES users(user_id),
	CONSTRAINT CHK_rating CHECK (rating >= 1 AND rating <= 5)
)

CREATE TABLE brewery_events (
	brewery_event_id int IDENTITY (1, 1),
	brewery_id int NOT NULL,
	title nvarchar(200) NOT NULL,
	description nvarchar(2000) NOT NULL,
	date_and_time datetime NOT NULL,
	CONSTRAINT PK_brewery_event_id PRIMARY KEY (brewery_event_id),
	CONSTRAINT FK_events_breweries FOREIGN KEY (brewery_id) REFERENCES breweries(brewery_id)
)

CREATE TABLE breweries_users (
brewery_id int NOT NULL,
user_id int NOT NULL,
CONSTRAINT PK_breweries_users_brewery_id_user_id PRIMARY KEY (brewery_id, user_id)
)

--populate default data

--user data
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('user','Jg45HuwT7PZkfuKTz6IB90CtWY4=','LHxP4Xh7bN0=','user');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('admin','YhyGVQ+Ch69n4JMBncM4lNF/i9s=', 'Ar/aB2thQTI=','admin');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('Masthead_Brewing_Co.','Jg45HuwT7PZkfuKTz6IB90CtWY4=', 'LHxP4Xh7bN0=','brewer');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('Southern_Tier_Brewing_Cleveland','Jg45HuwT7PZkfuKTz6IB90CtWY4=', 'LHxP4Xh7bN0=','brewer');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('Forest_City_Brewery','Jg45HuwT7PZkfuKTz6IB90CtWY4=', 'LHxP4Xh7bN0=','brewer');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('Platform_Beer_Co','Jg45HuwT7PZkfuKTz6IB90CtWY4=', 'LHxP4Xh7bN0=','brewer');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('Noble_Beast_Brewing_Co','Jg45HuwT7PZkfuKTz6IB90CtWY4=', 'LHxP4Xh7bN0=','brewer');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('Bookhouse_Brewing','Jg45HuwT7PZkfuKTz6IB90CtWY4=', 'LHxP4Xh7bN0=','brewer');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('Market_Garden_Brewing','Jg45HuwT7PZkfuKTz6IB90CtWY4=', 'LHxP4Xh7bN0=','brewer');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('Saucy_Brew_Works','Jg45HuwT7PZkfuKTz6IB90CtWY4=', 'LHxP4Xh7bN0=','brewer');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('Terrestrial_Brewing_Company','Jg45HuwT7PZkfuKTz6IB90CtWY4=', 'LHxP4Xh7bN0=','brewer');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('Brick_And_Barrel','Jg45HuwT7PZkfuKTz6IB90CtWY4=', 'LHxP4Xh7bN0=','brewer');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('Collision_Bend_Brewing_Company','Jg45HuwT7PZkfuKTz6IB90CtWY4=', 'LHxP4Xh7bN0=','brewer');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('Hansa_Brewery','Jg45HuwT7PZkfuKTz6IB90CtWY4=', 'LHxP4Xh7bN0=','brewer');


--breweries data
INSERT INTO breweries (user_id, brewery_name, history, street_address, phone, city, zip_code, is_active)
VALUES ('3','Masthead Brewing Co.', 'Expansive brewery & taproom pouring American & Belgian beer paired with wood-fired pizza.', '1261 Superior Ave', '216-206-6176', 'Cleveland', '44114', 'true');
INSERT INTO breweries (user_id, brewery_name, history, street_address, phone, city, zip_code, is_active)
VALUES ('4','Southern Tier Brewery', 'Exploration is the line from local beer maker to World-Class Brewer.', '811 Prospect Ave E,', '440-484-4045', 'Cleveland', '44115', 'true');
INSERT INTO breweries (user_id, brewery_name, history, street_address, phone, city, zip_code, is_active)
VALUES ('5','Forest City Brewery', 'Great atmosphere. Off the beaten path.Feels like a hidden treasure', ' 2135 Columbus Rd, Cleveland', '2162289116', 'Cleveland', '44113', 'true');
INSERT INTO breweries (user_id, brewery_name, history, street_address, phone, city, zip_code, is_active)
VALUES ('6','Platform Beer Co.', 'Opened in 2014, this 100+ seat tasting room and patio offers 20+ house beers and food options. ', '4125 Lorain Ave', '216-202-1386', 'Cleveland', '44113', 'true');
INSERT INTO breweries (user_id, brewery_name, history, street_address, phone, city, zip_code, is_active)
VALUES ('7','Noble Beast Brewing Co', 'Lively taproom for house-brewed beers & elevated bar snacks, sandwiches and salads.', '1470 Lakeside Ave E', '216-417-8588', 'Cleveland', '44114', 'true');
INSERT INTO breweries (user_id, brewery_name, history, street_address, phone, city, zip_code, is_active)
VALUES ('8','Bookhouse Brewing', 'Bookhouse Brewing focuses on making understated, slightly different beers and ciders, served in a
cozy, welcoming atmosphere.', '1526 W 25th St', '216-862-4048', 'Cleveland', '44113', 'true');
INSERT INTO breweries (user_id, brewery_name, history, street_address, phone, city, zip_code, is_active)
VALUES ('9','Market Garden Brewing', 'American gastropub with a patio, house beers, a distillery & a menu of creative sandwiches & tacos.', '1947 W 25th St', '216-621-4000', 'Cleveland', '44113', 'true');
INSERT INTO breweries (user_id, brewery_name, history, street_address, phone, city, zip_code, is_active)
VALUES ('10','Saucy Brew Works', 'Two-tiered brewery offering housemade European-style beer & customizable thin-crust pizzas.', '2885 Detroit Ave', '216-666-2568', 'Cleveland', '44113', 'true');
INSERT INTO breweries (user_id, brewery_name, history, street_address, phone, city, zip_code, is_active)
VALUES ('11','Terrestrial Brewing Company', 'Two-tiered brewery offering housemade European-style beer & customizable thin-crust pizzas.', '7524 Father Frascati', '216-465-9999', 'Cleveland', '44102', 'true');
INSERT INTO breweries (user_id, brewery_name, history, street_address, phone, city, zip_code, is_active)
VALUES ('12','Brick And Barrel', 'Taphouse offering house-brewed ales & wine in a cozy space with beer-centric decor.', '1844 Columbus Rd', '216-331-3308', 'Cleveland', '44113', 'true');
INSERT INTO breweries (user_id, brewery_name, history, street_address, phone, city, zip_code, is_active)
VALUES ('13','Collision Bend Brewing Company', 'Fashionable waterfront brewery & taproom for house-brewed beers & New American small plates.', '1250 Old River Rd', '216-273-7879', 'Cleveland', '44113', 'true');
INSERT INTO breweries (user_id, brewery_name, history, street_address, phone, city, zip_code, is_active)
VALUES ('14','Hansa Brewery', 'Brewery, biergarten & eatery offering German-style beer & European eats in modern digs with a patio.', ' 2717 Lorain Ave', '216-631-6585', 'Cleveland', '44113', 'true');

--hours data
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (1, '1', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (1, '2', '11', '30', 'am', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (1, '3', '11', '30', 'am', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (1, '4', '11', '30', 'am', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (1, '5', '11', '30', 'am', '11', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (1, '6', '11', '30', 'am', '11', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (1, '7', '11', '30', 'am', '8', '00', 'pm','1');

INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (2, '1', '11', '00', 'am', '8', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (2, '2', '11', '00', 'am', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (2, '3', '3', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (2, '4', '11', '00', 'am', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (2, '5', '3', '00', 'am', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (2, '6', '11', '00', 'am', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (2, '7', '11', '00', 'am', '12', '00', 'am','1');

INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (3, '1', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (3, '2', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (3, '3', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (3, '4', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (3, '5', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (3, '6', '12', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (3, '7', '12', '00', 'pm', '10', '00', 'pm','1');

INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (4, '1', '3', '00', 'pm', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (4, '2', '3', '00', 'pm', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (4, '3', '3', '00', 'pm', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (4, '4', '3', '00', 'pm', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (4, '5', '3', '00', 'pm', '2', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (4, '6', '11', '00', 'am', '2', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (4, '7', '11', '00', 'am', '10', '00', 'pm','1');

INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (5, '1', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (5, '2', '11', '30', 'am', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (5, '3', '11', '30', 'am', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (5, '4', '11', '30', 'am', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (5, '5', '11', '30', 'am', '11', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (5, '6', '11', '30', 'am', '11', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (5, '7', '11', '30', 'am', '10', '00', 'pm','1');

INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (6, '1', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (6, '2', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (6, '3', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (6, '4', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (6, '5', '3', '00', 'pm', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (6, '6', '12', '00', 'am', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (6, '7', '1', '00', 'pm', '6', '00', 'pm','1');

INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (7, '1', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (7, '2', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (7, '3', '3', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (7, '4', '3', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (7, '5', '2', '00', 'pm', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (7, '6', '11', '00', 'am', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (7, '7', '11', '00', 'am', '10', '00', 'pm','1');

INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (8, '1', '11', '00', 'am', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (8, '2', '11', '00', 'am', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (8, '3', '11', '00', 'am', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (8, '4', '11', '00', 'am', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (8, '5', '11', '00', 'am', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (8, '6', '11', '00', 'am', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (8, '7', '11', '00', 'am', '10', '00', 'pm','1');

INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (9, '1', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (9, '2', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (9, '3', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (9, '4', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (9, '5', '4', '00', 'pm', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (9, '6', '10', '00', 'am', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (9, '7', '10', '00', 'am', '10', '00', 'pm','1');

INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (10, '1', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (10, '2', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (10, '3', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (10, '4', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (10, '5', '2', '00', 'pm', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (10, '6', '12', '00', 'pm', '12', '00', 'am','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (10, '7', '12', '00', 'am', '8', '00', 'pm','1');

INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (11, '1', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (11, '2', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (11, '3', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (11, '4', '4', '00', 'pm', '10', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (11, '5', '3', '00', 'pm', '9', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (11, '6', '3', '00', 'pm', '11', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (11, '7', '11', '30', 'am', '5', '00', 'pm','1');

INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (12, '1', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (12, '2', '0', '0', '0', '0', '0', '0','0');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (12, '3', '12', '00', 'pm', '8', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (12, '4', '12', '00', 'pm', '8', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (12, '5', '12', '00', 'pm', '9', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (12, '6', '12', '00', 'pm', '9', '00', 'pm','1');
INSERT INTO hours (brewery_id, day_of_week, open_hour, open_minute, open_am_pm, close_hour, close_minute, close_am_pm, is_closed)
VALUES (12, '7', '0', '0', '0', '0', '0', '0','0');


--brewery images data
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (1, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618175380/jphovma3jurugvtnhxul.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (1, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618175377/mirjlbykemkvjgabkfuy.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (1, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618181008/rltilfui6kcaco6fm2yx.jpg');

INSERT INTO brewery_images (brewery_id, image_url)
VALUES (2, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618181372/slhiog2l8ldzu0cwrbbg.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (2, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618181379/nle8fimghyz05muqenms.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (2, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618181476/rmdfq9apm8j7lu2thdf3.jpg');

INSERT INTO brewery_images (brewery_id, image_url)
VALUES (3, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618181822/mdrypkcwnarqgg6mstx5.png');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (3, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618181826/xu7uic8wlyt6tlmxfcy3.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (3, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618181831/rf527qomkc70iuzsuzbb.jpg');

INSERT INTO brewery_images (brewery_id, image_url)
VALUES (4, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618182100/yaxe8fqkhgnw4maybn9b.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (4, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618182104/nvfoidgezn8odc9mhbki.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (4, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618182107/bhzaep1loytmhkrjmuvx.jpg');

INSERT INTO brewery_images (brewery_id, image_url)
VALUES (5, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618182476/flmd2iwx1aovcxlp2pe5.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (5, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618182479/urelulfllknebmb6y0gn.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (5, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618182483/meecslltpfkxdcbhtcrp.jpg');

INSERT INTO brewery_images (brewery_id, image_url)
VALUES (6, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618182718/epudo5agw7rnmuxdjmll.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (6, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618182721/xi4oddx6fyqtlyfb8jjx.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (6, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618182726/ue85dfrrvzd4xyf6ptwr.jpg');

INSERT INTO brewery_images (brewery_id, image_url)
VALUES (7, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618183090/waycotlsfd3jvsqys8ww.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (7, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618183093/ph8n4pdgtwgnkmz7pml3.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (7, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618183097/uzfbd0itxytzvrpch7xp.jpg');

INSERT INTO brewery_images (brewery_id, image_url)
VALUES (8, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618183630/ddcd8rpilegnynphffrb.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (8, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618183633/hxbkhcdsduzltt4fz7lx.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (8, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618183637/q8thzmg38jyo5srsdyhm.jpg');

INSERT INTO brewery_images (brewery_id, image_url)
VALUES (9, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618184759/foyw5jkzwvtv7jbgqjrq.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (9, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618184763/benflhsl3lnu7bod2bbk.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (9, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618184766/zq7ztnxbn5phrduoq3vv.jpg');

INSERT INTO brewery_images (brewery_id, image_url)
VALUES (10, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618185425/cmm1joj93xsjttnlzyin.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (10, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618185429/hobizh0gal8bpztf5dtg.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (10, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618185433/crhpn4jwlvuzqci7hlkn.jpg');

INSERT INTO brewery_images (brewery_id, image_url)
VALUES (11, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618185651/xifrglvr4wl2j4wvnzgp.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (11, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618185654/cg6mto3x25p5nq01ptuw.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (11, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618185665/srwhpii3oqvnogaaq1x4.png');

INSERT INTO brewery_images (brewery_id, image_url)
VALUES (12, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618185917/khdf2nlqeidqransbpdt.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (12, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618185921/kll3kbycfgbdrzpdlvl8.jpg');
INSERT INTO brewery_images (brewery_id, image_url)
VALUES (12, 'https://res.cloudinary.com/breweryfinderte/image/upload/v1618185983/hoj9erozy2ci1urt3mdh.jpg');







GO


