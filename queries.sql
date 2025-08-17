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
WHERE fl.origin IN ('EWR') AND al.carrier IN ('HA');