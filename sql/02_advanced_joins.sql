SELECT * 
FROM airlines
LIMIT 20;

SELECT *
FROM airports
LIMIT 20;

SELECT * 
FROM flights
LIMIT 20;

SELECT * 
FROM planes
LIMIT 20;

SELECT *
FROM weather
LIMIT 20;

-- У какого самолёта самое большое количество рейсов и его компания
SELECT pl.tailnum, fl.carrier, al.name AS airline_name, COUNT(*) AS flight_count
FROM planes AS pl
INNER JOIN flights AS fl
USING(tailnum)
INNER JOIN airlines AS al 
USING(carrier)
GROUP BY pl.tailnum, fl.carrier, al.name  -- группируем по всем трём полям
ORDER BY flight_count DESC
/* Самое большое кол-во рейсов у самолёта с tailnum=N711MQ компании Envoy Air, он совершил 18 рейсов */;
SELECT tailnum, COUNT(DISTINCT carrier) as carriers_count
FROM flights
GROUP BY tailnum
HAVING COUNT(DISTINCT carrier) > 1
ORDER BY carriers_count DESC
/* ДО поделения на carrier было 3322 строки, после - 3326
Запрос выше показывает, сколько и какие имменно самолёты летали больше чем за одну компанию
*/;

-- Простой запрос на FULL JOIN
SELECT carrier, al.name, fl.month, fl.minute, fl.dep_time
FROM airlines as al
FULL JOIN flights as fl
USING(carrier)
WHERE carrier IN ('UA', 'AA') AND fl.month=6;

-- Простой запрос на CROSS JOIN
SELECT fl.dest, fl.origin, al.name
FROM flights AS fl
CROSS JOIN airlines AS al
WHERE fl.origin IN ('JFK') AND al.carrier IN ('HA');


-- SELF JOIN (сравнивать колонку с разными значениями в ней самой, в одной таблице)

-- Сейчас написал сравнение дней в колонке по месяцам из flights
SELECT fl1.day AS day1, fl2.day AS day2, fl1.month
FROM flights AS fl1
INNER JOIN flights AS fl2
ON fl1.month=fl2.month
AND fl1.day<>fl2.day -- не равно
LIMIT 40
/* Запрос (условно): 
Берёт сначала «1-й день января со всеми остальными днями января»,
потом «2-й день января со всеми остальными»,
*/;

SELECT fl1.flight AS first_flight, fl2.flight AS second_flight, fl1.origin AS first_origin, fl2.origin AS second_origin, fl1.dest, fl2.sched_arr_time AS second_arr_time, fl1.sched_arr_time AS first_arr_time, fl1.sched_arr_time - fl2.sched_arr_time AS difference
FROM flights AS fl1
INNER JOIN flights AS fl2
ON fl1.dest = fl2.dest
AND fl1.day = fl2.day
AND fl1.month = fl2.month
AND fl1.sched_arr_time > fl2.sched_arr_time
AND (fl1.sched_arr_time - fl2.sched_arr_time) <= 5
ORDER BY difference ASC
/* Данный SQL-запрос выполняет поиск пар рейсов с одинаковым пунктом назначения (dest), 
которые прибывают в один и тот же день с интервалом не более 5 минут */;