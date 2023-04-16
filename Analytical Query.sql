-- Mencari mobil keluaran 2015 ke atas
SELECT
	*
FROM cars
	WHERE year >= 2015;
	
-- Menambahkan satu data bid produk baru
INSERT INTO bids(bid_id, ads_id, buyer_id, bid_price, bid_status, date_bid)
VALUES(201,50,25,200000000,'Sent',TO_DATE('30/11/2022', 'DD/MM/YYYY'))

-- Melihat mobil yang dijual 1 akun dari yang paling baru
SELECT
	c.product_id,
	c.brand,
	c.model,
	c.year,
	c.price,
	a.date_post
FROM cars c, ads a, sellers s
	WHERE seller_name = 'Bagus Sitorus'
		AND s.seller_id = a.seller_id
		AND a.product_id = c.product_id
ORDER BY a.date_post DESC;

-- Mencari mobil termurah berdasarkan keyword
SELECT
	*
FROM cars
	WHERE model ILIKE '%yaris%'
ORDER BY price ASC
LIMIT 5;

-- Mencari mobil terdekat berdasarkan sebuah id kota
SELECT
	c.product_id,
	c.brand,
	c.model,
	c.year,
	c.price,
	haversine_distance((ct.coordinate), (SELECT coordinate FROM cities WHERE city_id = 3173)) as distance
FROM cars c, ads a, sellers s, cities ct
	WHERE a.product_id = c.product_id
		AND a.seller_id = s.seller_id
		AND s.city_id = ct.city_id
ORDER BY distance
LIMIT 3;