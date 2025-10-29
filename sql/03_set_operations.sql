-- Airlines with CASE logic
SELECT
    CASE
        WHEN UPPER(LEFT(name, 1)) IN ('A', 'E', 'I', 'O', 'U')
        THEN 'airlines_vowel'
        ELSE 'airlines_consonant'   
    END AS entity_type, name
FROM airlines
UNION ALL

SELECT 'airports', name -- for subsequent SELECT statements, you do not need to specify the name in your column
FROM airports
UNION ALL

SELECT 'manufacturer', manufacturer
FROM planes
WHERE manufacturer IS NOT NULL; -- Exclude empty values


--INTERSECT

--№1----------------------------
-- Airlines that fly from all three NYC airports
SELECT carrier FROM flights WHERE origin = 'JFK'
INTERSECT
SELECT carrier FROM flights WHERE origin = 'LGA'
INTERSECT  
SELECT carrier FROM flights WHERE origin = 'EWR';
--------------------------

--№2----------------------------
-- How often each airline flies from NYC?
SELECT carrier, COUNT(*) as flights_count
FROM flights 
WHERE carrier IN ('AA', 'B6', 'DL', 'UA', 'US', 'MQ', 'EV', '9E') -- previous query result
GROUP BY carrier
ORDER BY flights_count DESC;
--------------------------

--№3----------------------------
-- Destinations served by both American Airlines and Delta
SELECT dest 
FROM flights
WHERE carrier = 'AA'
INTERSECT
SELECT dest 
FROM flights 
WHERE carrier = 'DL';
--------------------------


-- EXCEPT

-- Which airports are arrival destinations but never departure origins?
SELECT origin
FROM flights
EXCEPT
SELECT dest
FROM flights;

-- Which airports are departure origins but never arrival destinations?
SELECT dest
FROM flights
EXCEPT
SELECT origin
FROM flights;


-- Aircraft that are in the registry but have never flown
SELECT tailnum 
FROM planes
EXCEPT
SELECT tailnum 
FROM flights 
WHERE tailnum IS NOT NULL; -- 998 aircraft have never flown
