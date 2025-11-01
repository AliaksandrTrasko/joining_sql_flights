# Detailed SQL Analysis
This document provides a query-by-query breakdown of the findings from the SQL analysis. The queries are grouped by the original script files.

---

## 1. `01_basic_joins.sql`

### [How many flights were there in the 5th month)](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/01_basic_joins.sql#L1)
* **Key Finding:**  
ExpressJet Airlines Inc. had the most flights in May (143), with United Air Lines Inc. (131) and JetBlue Airways (121) close behind.

### [Which company has the fewest delays (arr_delay <= 0)](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/01_basic_joins.sql#L10)
* **Key Finding:**  
United Air Lines Inc. leads in absolute numbers (1,051), followed by Delta Air Lines Inc. (925)

### [Count the total number of flights for each airline](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/01_basic_joins.sql#L19C3-L19C53)
* **Key Finding:**  
United Air Lines Inc. is the most active carrier with 1,741 flights, followed by ExpressJet Airlines Inc. (1,643) and JetBlue Airways (1,636)

* **Insight:**  
Throughout the year, the Top 3 are almost equal (the difference is 6.4%), which indicates balanced competition rather than a monopoly

### [How weather affected delays. Lower 'visib' means worse visibility](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/01_basic_joins.sql#L27C4-L27C69)
* **Key Finding:**  
The data shows a weak correlation. Surprisingly, the highest average delay (113.50 min) occurs at a relatively good visibility of 9 miles, which means delays are caused by factors other than just visibility

### [Average age of planes for each airline](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/01_basic_joins.sql#L36C4-L37C1)
* **Description:**
The first part (avg_age) of the code shows the average age of aircraft in each company. The top three companies in terms of number of flights were not among the top in terms of average age. I decided to create a visualization to see the number of flights per company and the average age of aircraft together.

* **Key Finding:**  
The visualization shows that the newest aircraft belong to companies with the lowest number of flights. This most likely indicates that these companies are young (as of 2013, when the statistics were compiled).

---

## 2. `02_advanced_joins`

### [Find the aircraft with the most flights and its airline](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/02_advanced_joins.sql#L21)
* **Insight**
This query revealed a key difference between SQL and pandas: SQL's `LEFT JOIN` + `GROUP BY` INCLUDES planes that never flew (998 aircraft), while pandas' default `.groupby()` DROPS them
1. If I want (in pandas) to include all values - add dropna=False in groupby()
2. If I want (SQL) to drop NaN (NULL in SQL) values in SQL - just use INNER JOIN (in THIS case its useful)
* **Key Finding:**  
Aircraft N335AA and N711MQ are most active with 18 flights each. Many planes in the fleet have flown many times (>10)

### [A simple query for FULL JOIN](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/02_advanced_joins.sql#L39)
* **Key Finding:**  
Shows 236 departures from American and United Airlines in June. Full connection keeps all airline and flight records, even those that don't match on "carrier" column

### [A simple query for CROSS JOIN](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/02_advanced_joins.sql#L46C4-L46C33)
* **Conclusion**
Basically, this code doesn't make real sense: it just multiplies all values from airlines_df with flights_df regardless of whether the flight actually exists, and then filters afterwards

### [Query finds pairs of flights with the same destination and arrival time that differs by a maximum of 5 minutes](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/02_advanced_joins.sql#L66)
* **Key Finding:**  
This self-join finds flight pairs scheduled to arrive at the same airport on the same day within 5 minutes of each other. The results show potential airport congestion with 5 conflicting flight pairs identified (where origin and destination are identical)

---

## 3. `03_set_operations`

### [Airlines that fly from all three NYC airports](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/03_set_operations.sql#L23)
* **Key Finding:** 
Only 8 of the 16 airlines listed in the database operate flights from all three major New York airports. 
This suggests that operating from all three major New York airports is relatively uncommon among airlines

### [Destinations served by both American Airlines and Delta?](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/03_set_operations.sql#L41)
* **Key Finding**: 
American Airlines (AA) and Delta Air Lines (DL) serve 14 common destinations
* **Insight**:
This significant route overlap between two major airlines indicates intense competition on popular routes including transcontinental (LAX, SFO, SEA) and Florida (MIA, FLL, MCO) markets

### [Which airports are departure origins but never arrival destinations?](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/03_set_operations.sql#L61)
* **Key Finding:**
This shows that the database being analyzed collected flight statistics only from three New York airports (3) to other US airports (99) 

### [Aircraft that are in the registry but have never flown](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/03_set_operations.sql#L69)
* **Key Finding:**
998 aircraft in the registry have never conducted any flights.
* **Insight:**
This represents significant unused capacity in the aviation system

---

## 4. `04_subqueries`

### [Flights operated by Boeing 737](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/04_subqueries.sql#L4)
* **Initial Dataset Overview**
* * Total aircraft in registry: 3,322 planes
* * Boeing 737 models in registry: 1,037 planes (31.2%)
* * Total flights recorded: ~10,000 flights
* * Flights operated by 737s: 1,518 flights (15.2%)
* **Key Finding:**
Boeing 737 aircraft account for 31.2% of the total number of registered aircraft, 
but operate only 15.2% of all flights, indicating a relatively low load factor compared to their share in the registry.
* **Refined Analysis:**
When considering only aircraft that have actually flown (based on last query from 03_set_operations):
* * Active aircraft total: 2,324 planes
* * Active Boeing 737s: 595 planes (25.6%)
* **Insight:**
The utilization gap becomes more understandable - 25.6% of the active fleet (Boeing 737s) conducts 15.2% of flights.
While still showing lower-than-expected utilization, this refined perspective reveals that many 737s in the registry are likely not in active service, making the operational percentage more reasonable.

### [Flights to airports on the East Coast](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/04_subqueries.sql#L13)
* **Key Finding:**
1,868 flights (18.7% of total) served East Coast destinations, primarily to major hubs like BOS and RDU.
* **Insight:**
The analysis filtered destinations east of 80°W longitude, showing significant traffic concentration along the Eastern seaboard from NYC airports.

### [For each airport, show the number of flights departing FROM it](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/04_subqueries.sql#L24)
* **Key Finding:**
EWR leads with 3,645 departures, followed by JFK (3,276) and LGA (3,079).
* **Insight:** All three NYC airports maintain relatively balanced operations, with EWR handling the highest volume despite JFK's international prominence.

### [For each aircraft, show the total number of flights](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/04_subqueries.sql#L44)
* **Key Finding:**
While top aircraft show heavy usage (17-20 flights each), the fleet-wide average is only 3.54 flights per aircraft.
* **Insight:**
This indicates a highly skewed unimodal distribution, with most aircraft flying very infrequently and a small portion of the fleet performing the bulk of operations. The low average reflects significant idle capacity across the registry, despite the efficient utilization of core aircraft.

### [Average flight distance for each aircraft (by 'tailnum')](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/04_subqueries.sql#L55)
* **Key Finding:**
Individual aircraft operated by Hawaiian Airlines (Airbus A330-243) record the longest average distances - 4,983 miles. 
Smaller regional jets and turboprops (e.g., Embraer ERJ 190-100 and Bombardier CL-600) show significantly lower averages - under 200 miles.
* **Insight:**
This contrast shows how the aircraft model and the airline's route network together determine flight length. 
Wide-body Airbus A330 aircraft are designed for long-haul flights, while regional aircraft are designed for short domestic flights. 
The dataset clearly separates the use of the aircraft fleet for long-haul flights and aircraft for short flights, highlighting the specialization of the aircraft fleet within airlines.

### [Average flight delays by month and airline](https://github.com/AliaksandrTrasko/joining_sql_flights/blob/f65f3148161cb27c657be27aaf0baf366bb0bdf1/sql/04_subqueries.sql#L65C4-L65C46)
* **Key Finding:**
Initially, the top of the ranking was dominated by airlines with only 1–2 recorded flights, leading to unrealistic averages.
After filtering for carriers with more than five flights, the highest mean delays were observed for Endeavor Air Inc. and Southwest Airlines Co., exceeding 50 and 45 minutes on average per month.
However, median delays for these and most other carriers remained close to zero, indicating that while a few flights experience severe delays, the majority of flights depart on time or even slightly early.
* **Insight:**
This contrast between mean and median delay highlights the influence of outliers - rare but significant disruptions that inflate the average delay.
Most carriers maintain generally punctual operations, with only a small number of long delays skewing the mean upward.
Therefore, median delay provides a *more realistic measure* of typical passenger experience, while mean delay reflects sensitivity to *occasional extreme events*.
* **Conclusion:**
Although certain airlines show high average delay times, their median performance suggests overall reliability.
Travelers can interpret this as: these carriers are usually on time, but when delays do occur, they tend to be long and infrequent.