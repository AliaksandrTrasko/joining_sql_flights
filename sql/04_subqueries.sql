-- SUBQUERIES

------ WHERE clause
-- Flights operated by Boeing 737
SELECT *
FROM flights
WHERE tailnum IN (
    SELECT tailnum
    FROM planes
    WHERE model LIKE '737%'
);

-- Flights to airports on the East Coast
SELECT *
FROM flights
WHERE dest IN (
    SELECT faa
    FROM airports
    WHERE lon > -80  -- east of 80° west longitude
);

------ SELECT clause

-- For each airport, show the number of flights departing FROM it
SELECT DISTINCT origin, 
    (SELECT COUNT(*)
    FROM flights AS f2
    WHERE f1.origin = f2.origin
    ) AS counts
FROM flights AS f1;
-- Instead of a subquery in SELECT
SELECT origin, COUNT(*) AS total_flights
FROM flights
GROUP BY origin;

-- Average delay at destination airport
SELECT fl1.dest,
    (SELECT ROUND(AVG(fl2.arr_delay), 2)
    FROM flights AS fl2
    WHERE fl1.dest=fl2.dest) AS avg_arr_delay
FROM flights AS fl1
LIMIT 10;

-- For each aircraft, show the total number of flights
SELECT DISTINCT tailnum,
       (SELECT COUNT(*)
        FROM flights f2
        WHERE f2.tailnum = f1.tailnum) AS flight_count
FROM flights f1
WHERE tailnum IS NOT NULL
LIMIT 10;

------ FROM clause

-- Average flight distance for each aircraft (by 'tailnum')
SELECT pl.tailnum, pl.manufacturer, pl.model,
       route_stats.avg_distance
FROM planes AS pl,
    (SELECT tailnum, ROUND(AVG(distance), 2) AS avg_distance
    FROM flights AS fl
    GROUP BY tailnum) AS route_stats
WHERE pl.tailnum = route_stats.tailnum
ORDER BY avg_distance DESC;

-- Average flight delays by month and airline

SELECT a.name, a.carrier,
       delay_stats.month,
       delay_stats.avg_delay,
       delay_stats.flight_count
FROM airlines AS a,
     (SELECT carrier, month,
             ROUND(AVG(dep_delay), 2) AS avg_delay,
             COUNT(*) AS flight_count
      FROM flights
      WHERE dep_delay IS NOT NULL
      GROUP BY carrier, month) AS delay_stats
WHERE a.carrier = delay_stats.carrier
  AND delay_stats.avg_delay > 15
  AND delay_stats.flight_count > 5
ORDER BY delay_stats.avg_delay DESC;
