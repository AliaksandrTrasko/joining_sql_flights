# NYC Flight Analysis for 2013 (SQL)


---
### Companion Project: Python (Pandas) Version

This project is one of two companion repositories demonstrating data analysis on the `nycflights13` dataset. This repository contains the analysis performed using **SQL (PostgreSQL)**.

For the same analysis performed using **Python (Pandas)**, please see the companion repository:
**[➡️ Python (Pandas) Flights Analysis](https://github.com/AliaksandrTrasko/joining_python_flights.git)**
---
---

This project is a series of analytical SQL queries performed on the public nycflights13 dataset, which contains information about all flights that departed from New York City airports (JFK, LGA, EWR) in 2013.

The goal of this project is to demonstrate SQL skills, including various JOIN types, UNION, INTERSECT, subqueries, and aggregate functions to extract useful insights from the data.


### **Project Structure**

```
├── data/                       # Folder with the source .csv dataset files
│   ├── airlines.csv
│   ├── airports.csv
│   └── ...
├── sql/                        # Folder with all the SQL scripts
│   ├── setup_fixed.sql         # Script to create tables and load data
│   ├── 01_basic_joins.sql      # Basic queries and aggregations
│   ├── 02_advanced_joins.sql   # Advanced joins (SELF, FULL, CROSS JOIN)
│   ├── 03_set_operations.sql   # Set operations (UNION, INTERSECT, EXCEPT)
│   └── 04_subqueries.sql       # Queries using subqueries
└── README.md                   # This file
```


### **Tools & Techniques**

* **DBMS**: PostgreSQL
* **Dataset**: [nycflights13](https://github.com/tidyverse/nycflights13.git)
* **Version Control**: Git


## Dataset

This project uses the **`nycflights13`** dataset, which contains detailed information on all 336,776 flights that departed from New York City (EWR, JFK, LGA) in 2013. The data is comprised of five related tables:
* `flights`
* `weather`
* `planes`
* `airports`
* `airlines`


## Key Insights
- Of the 3,322 aircraft in the registry, 998 of them have never flown, which is 30%. 
- The highest average age of aircraft in the company - 35 years (as for 2013) in Envoy Air with 769 flights.
- Several aircraft were used by several airlines.


### **How to Run This Project**
1. **Clone the repository:**
```bash
git clone https://github.com/AliaksandrTrasko/joining_sql_flights.git
cd [project-folder-name]
```
2. **Create a database in PostgreSQL:**
* Ensure that you have PostgreSQL installed and running
* Create an empty database with UTF-8 encoding
```bash
createdb -U postgres -E UTF8 flights_db
```
3. **Create tables and load the data:**
* From the project's root directory, execute the setup_fixed.sql script. It will automatically create all necessary tables and load the data from the data/ folder.
```bash
psql -U postgres -d flights_db -f sql/setup_fixed.sql
```
4. **Execute queries:**
* You can now connect to the database and run any queries from the 01-04 files or write your own.
```bash
psql -U postgres -d flights_db
```
---

### **Key Questions Explored:**

During the analysis, the following questions were answered:
* Is there a noticeable correlation between weather conditions and flight delays?
* Which aircraft were used by more than one airline?
* Which airlines fly out of all three NYC airports?
* Are there airports that flights only arrive at but do not depart from (within this dataset)?
* Which flights were operated by Boeing 737 aircraft?

**[➡️ For a detailed, query-by-query breakdown of the analysis, see ANALYSIS.md](ЗАПОЛНИТЬ ХУУУУУУУУУУУУУУУУУУУУУЙЙЙЙЙЙЙЙЙЙЙЙЙ)**
