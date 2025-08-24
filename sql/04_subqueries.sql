-- SUBQUERIES

------ WHERE clause
-- Рейсы, которые выполнялись на самолетах Boeing 737
SELECT *
FROM flights
WHERE tailnum IN (
    SELECT tailnum
    FROM planes
    WHERE model LIKE '737%'
);

-- Рейсы в аэропорты на восточном побережье
SELECT *
FROM flights
WHERE dest IN (
    SELECT faa
    FROM airports
    WHERE lon > -80  -- восточнее 80° западной долготы
);

------ SELECT clause (долгие)

-- Для каждого аэропорта показать количество рейсов из него
SELECT DISTINCT origin, 
    (SELECT COUNT(*)
    FROM flights AS f2
    WHERE f1.origin = f2.origin
    ) AS chto
FROM flights AS f1;
-- Вместо подзапроса в SELECT
SELECT origin, COUNT(*) AS total_flights
FROM flights
GROUP BY origin;

-- Для каждого самолета показать общее количество полетов
SELECT DISTINCT tailnum,
       (SELECT COUNT(*)
        FROM flights f2
        WHERE f2.tailnum = f1.tailnum) AS flight_count
FROM flights f1
WHERE tailnum IS NOT NULL
LIMIT 10;

------ FROM clause

SELECT pl.tailnum, pl.manufacturer, pl.model,
       route_stats.avg_distance
FROM planes AS pl,
    (SELECT tailnum, ROUND(AVG(distance), 2) AS avg_distance
    FROM flights AS fl
    GROUP BY tailnum) AS route_stats
WHERE pl.tailnum = route_stats.tailnum
ORDER BY avg_distance DESC;