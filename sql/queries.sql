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

--Сколько было перевозок за 5-й месяц
SELECT DISTINCT al.name, COUNT(*)
FROM airlines AS al
INNER JOIN flights as fl
USING(carrier)
WHERE fl.month = 5
GROUP BY al.name
ORDER BY COUNT(*) DESC;

--У какой компании меньше всего опозданий (dep_delay=0)
SELECT al.name, COUNT(fl.dep_delay) AS not_delay
FROM airlines AS al
INNER JOIN flights as fl
USING(carrier)
WHERE dep_delay<=0
GROUP BY al.name
ORDER BY not_delay DESC;

--Подсчёт сколько всего было полётов всех
SELECT al.name, COUNT(*)
FROM airlines AS al
INNER JOIN flights as fl
USING (carrier)
GROUP BY al.name
ORDER BY COUNT(*) DESC
/* Мы получили, что самая не опаздывающая компания имеет 984 не опозданий. 
Всего у неё 1636 рейс. 60.15% рейсов не опаздывают */;

-- Как погода влияла на опоздание. Чем меньше visib, тем хуже видно
SELECT we.visib, AVG(fl.dep_delay) AS avg_delay, COUNT(*) AS number_of_flights
FROM flights AS fl
INNER JOIN weather AS we 
ON fl.time_hour = we.time_hour AND fl.origin = we.origin
WHERE fl.dep_delay > 0
GROUP BY we.visib
ORDER BY we.visib DESC
/* На удивление, корреляция арактически незаметна*/;

--Средний возраст у самолётов каждой авиакомпании и кол-во рейсов
SELECT al.name AS airline_name, ROUND(AVG(p.year), 0) AS avg_plane_age
FROM flights AS fl
INNER JOIN airlines AS al ON fl.carrier = al.carrier
INNER JOIN planes AS p ON fl.tailnum = p.tailnum
GROUP BY al.name
ORDER BY avg_plane_age DESC;


----INTERMEDIATE CHAPT. 2

-- У какого самолёта самое большое количество рейсов и его компания
SELECT pl.tailnum, fl.carrier, al.name AS airline_name, COUNT(*) AS flight_count
FROM planes AS pl
LEFT JOIN flights AS fl
USING(tailnum)
LEFT JOIN airlines AS al 
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
WHERE carrier='UA' OR carrier='AA';

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
AND fl1.day<>fl2.day
LIMIT 40
/* Запрос (условно): 
Берёт первый рейс 1-го января из таблицы fl1.
Соединяет его со всеми сотнями рейсов, которые произошли 2-го января в таблице fl2.
Потом соединяет его со всеми сотнями рейсов 3-го января и т.д.
Затем он берёт второй рейс 1-го января и повторяет весь процесс.
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


-- UNION // UNION ALL - накладывают поля друг на друга
/* UNION - Если записи идентичны, UNION вернёт только одну запись
   UNION ALL - Вернёт абсолютно  все */
SELECT
    CASE
        WHEN UPPER(LEFT(name, 1)) IN ('A', 'E', 'I', 'O', 'U')
        THEN 'airlines_vowel'
        ELSE 'airlines_consonant'   
    END AS entity_type, name
FROM airlines
UNION ALL

SELECT 'airports', name -- для последующий SELECT в своей колонке не нужно указывать название
FROM airports
UNION ALL

SELECT 'manufacturer', manufacturer
FROM planes
WHERE manufacturer IS NOT NULL; -- Исключаем пустые значения


--INTERSECT

--№1----------------------------
-- Авиакомпании, которые летают из всех трех аэропортов NYC
SELECT carrier FROM flights WHERE origin = 'JFK'
INTERSECT
SELECT carrier FROM flights WHERE origin = 'LGA'
INTERSECT  
SELECT carrier FROM flights WHERE origin = 'EWR';
--------------------------

--№2----------------------------
-- Кто как часто летает из NYC
SELECT carrier, COUNT(*) as flights_count
FROM flights 
WHERE carrier IN ('AA', 'B6', 'DL', 'UA', 'US', 'MQ', 'EV', '9E') -- результат предыдущего запроса
GROUP BY carrier
ORDER BY flights_count DESC;
--------------------------

--№3----------------------------
-- Куда летали и American Airlines, и Delta
SELECT dest 
FROM flights
WHERE carrier = 'AA'
INTERSECT
SELECT dest 
FROM flights 
WHERE carrier = 'DL';
--------------------------


-- EXCEPT
-- Из каких аэропортов вылетают, в которые не прилетают?
SELECT origin
FROM flights
EXCEPT
SELECT dest
FROM flights;

-- В какие аэропорты прилетают, но из которых НЕ вылетают (из NYC)?
SELECT dest
FROM flights
EXCEPT
SELECT origin
FROM flights;


-- Самолеты, которые есть в регистре, но никогда не летали
SELECT tailnum 
FROM planes
EXCEPT
SELECT tailnum 
FROM flights 
WHERE tailnum IS NOT NULL; -- 998 самолётов ни разу не летали


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