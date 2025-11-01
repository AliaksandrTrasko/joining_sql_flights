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

-- How many flights were there in the 5th month
SELECT DISTINCT al.name, COUNT(*)
FROM airlines AS al 
INNER JOIN flights as fl
USING(carrier)
WHERE fl.month = 5
GROUP BY al.name
ORDER BY COUNT(*) DESC;

-- Which company has the fewest delays (arr_delay <= 0)
SELECT al.name, COUNT(fl.arr_delay) AS not_delay
FROM airlines AS al
INNER JOIN flights as fl
USING(carrier)
WHERE arr_delay<=0
GROUP BY al.name
ORDER BY not_delay DESC;

-- Count the total number of flights for each airline
SELECT al.name, COUNT(*)
FROM airlines AS al
INNER JOIN flights as fl
USING (carrier)
GROUP BY al.name
ORDER BY COUNT(*) DESC

-- How weather affected delays. Lower 'visib' means worse visibility
SELECT we.visib, AVG(fl.dep_delay) AS avg_delay, COUNT(*) AS number_of_flights
FROM flights AS fl
INNER JOIN weather AS we 
ON fl.time_hour = we.time_hour AND fl.origin = we.origin
WHERE fl.dep_delay > 0
GROUP BY we.visib
ORDER BY we.visib DESC

-- Average age of planes for each airline
SELECT al.name AS airline_name, ROUND(AVG(p.year), 0) AS avg_plane_age
FROM flights AS fl
INNER JOIN airlines AS al 
ON fl.carrier = al.carrier
INNER JOIN planes AS p 
ON fl.tailnum = p.tailnum
GROUP BY al.name
ORDER BY avg_plane_age DESC;