-- Ranking popularitas model mobil berdasarkan jumlah bid
SELECT
	c.model,
	COUNT(c.product_id) AS count_product,
	COUNT(b.bid_id) AS count_bid
FROM cars c, ads a, bids b
	WHERE c.product_id = a.product_id
		AND a.ads_id = b.ads_id
GROUP BY c.model
ORDER BY count_bid DESC;

-- Membandingkan harga mobil berdasarkan harga rata-rata per kota
SELECT
	ct.city_name,
	c.brand,
	c.model,
	c.year,
	c.price,
	AVG(c.price) OVER(PARTITION BY ct.city_name) AS avg_per_city
FROM cars c, ads a, sellers s, cities ct
	WHERE a.product_id = c.product_id
		AND a.seller_id = s.seller_id
		AND s.city_id = ct.city_id;
		
-- Dari penawaran suatu model mobil, cari perbandingan tanggal user melakukan bid dengan bid selanjutnya beserta harga tawar yang diberikan
SELECT
	model,
	buyer_id,
	date_bid AS first_bid_date,
	bid_price AS first_bid_price
FROM(
	SELECT
		c.model,
		b.buyer_id,
		b.date_bid,
		b.bid_price,
		min(b.date_bid) OVER(PARTITION BY c.model, b.buyer_id) AS min_date
	FROM cars c, ads a, bids b
		WHERE c.product_id = a.product_id
			AND a.ads_id = b.ads_id
	) t
WHERE date_bid = min_date;

-- Membandingkan persentase perbedaan rata-rata harga mobil berdasarkan modelnya dan rata-rata harga bid yang ditawarkan oleh customer pada 6 bulan terakhir
SELECT
	c.model,
	AVG(c.price) AS avg_price,
	AVG(b.bid_price) AS avg_bid_6month,
	AVG(c.price) - AVG(b.bid_price) AS difference,
	(AVG(c.price) - AVG(b.bid_price))/AVG(c.price) AS difference_percent
FROM cars c, ads a, bids b
	WHERE c.product_id = a.product_id
		AND a.ads_id = b.ads_id
		AND b.date_bid BETWEEN '2022/07/01' AND '2022/12/31'
GROUP BY c.model