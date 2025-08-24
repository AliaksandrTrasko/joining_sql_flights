/*  UNION // UNION ALL - накладывают поля друг на друга
    UNION - Если записи идентичны, UNION вернёт только одну запись
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