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

------   clause (долгие)

-- Для каждого аэропорта показать количество рейсов ИЗ него
SELECT DISTINCT origin, 
    (SELECT COUNT(*)
    FROM flights AS f2
    WHERE f1.origin = f2.origin
    ) AS counts
FROM flights AS f1;
-- Вместо подзапроса в SELECT
SELECT origin, COUNT(*) AS total_flights
FROM flights
GROUP BY origin;

-- Средняя задержка по аэропорту назначения
SELECT fl1.dest,
    (SELECT ROUND(AVG(fl2.arr_delay), 2)
    FROM flights AS fl2
    WHERE fl1.dest=fl2.dest) AS avg_arr_delay
FROM flights AS fl1
LIMIT 10;

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
ORDER BY delay_stats.avg_delay DESC;
