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

-- Find the aircraft with the most flights and its airline
SELECT pl.tailnum, fl.carrier, al.name AS airline_name, COUNT(*) AS flight_count
FROM planes AS pl
INNER JOIN flights AS fl
USING(tailnum)
INNER JOIN airlines AS al 
USING(carrier)
GROUP BY pl.tailnum, fl.carrier, al.name  -- group by all three fields
ORDER BY flight_count DESC
/* The aircraft with tailnum=N711MQ, operated by Envoy Air, has the highest number of flights, having completed 18 flights */;;
SELECT tailnum, COUNT(DISTINCT carrier) as carriers_count
FROM flights
GROUP BY tailnum
HAVING COUNT(DISTINCT carrier) > 1
ORDER BY carriers_count DESC
/* Before splitting into carriers, there were 3322 lines; after splitting, there were 3326 lines.
The query above shows which aircraft and how many flew for more than one airline*/;

-- A simple query for FULL JOIN
SELECT carrier, al.name, fl.month, fl.minute, fl.dep_time
FROM airlines as al
FULL JOIN flights as fl
USING(carrier)
WHERE carrier IN ('UA', 'AA') AND fl.month=6;

-- A simple query for CROSS JOIN
SELECT fl.dest, fl.origin, al.name
FROM flights AS fl
CROSS JOIN airlines AS al
WHERE fl.origin IN ('JFK') AND al.carrier IN ('HA');


-- A simple query for SELF JOIN (compare a column with different values within it, in a single table)

-- I just wrote a comparison of days in a column by month from flights.
SELECT fl1.day AS day1, fl2.day AS day2, fl1.month
FROM flights AS fl1
INNER JOIN flights AS fl2
ON fl1.month=fl2.month
AND fl1.day<>fl2.day -- не равно
LIMIT 40
/* Query: 
First, take “the 1st day of January with all other days of January,”
then “the 2nd day of January with all others,”*/;

-- This query finds pairs of flights with the same destination (dest)
-- that arrive on the same day with an interval of no more than 5 minutes
SELECT fl1.flight AS first_flight, fl2.flight AS second_flight, fl1.origin AS first_origin, fl2.origin AS second_origin, fl1.dest, fl2.sched_arr_time AS second_arr_time, fl1.sched_arr_time AS first_arr_time, fl1.sched_arr_time - fl2.sched_arr_time AS difference
FROM flights AS fl1
INNER JOIN flights AS fl2
ON fl1.dest = fl2.dest
AND fl1.day = fl2.day
AND fl1.month = fl2.month
AND fl1.sched_arr_time > fl2.sched_arr_time
AND (fl1.sched_arr_time - fl2.sched_arr_time) <= 5
ORDER BY difference ASC;