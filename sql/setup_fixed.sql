\encoding UTF8

-- Дата в формате ISO
SET datestyle TO 'ISO, MDY';

-- Удаляем таблицы, если они есть
DROP TABLE IF EXISTS flights, weather, planes, airports, airlines;

-- Создание таблиц без внешних ключей (для удобной загрузки)
CREATE TABLE airlines (
    carrier CHAR(2) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE airports (
    faa CHAR(3) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    lat NUMERIC(10,7) NOT NULL,
    lon NUMERIC(10,7) NOT NULL,
    alt INTEGER NOT NULL,
    tz INTEGER NOT NULL,
    dst CHAR(1) NOT NULL,
    tzone VARCHAR(255)
);

CREATE TABLE planes (
    tailnum VARCHAR(6) PRIMARY KEY,
    year SMALLINT,
    type VARCHAR(255),
    manufacturer VARCHAR(255),
    model VARCHAR(255),
    engines SMALLINT,
    seats SMALLINT,
    speed SMALLINT,
    engine VARCHAR(255)
);

CREATE TABLE weather (
    origin CHAR(3) NOT NULL,
    year SMALLINT NOT NULL,
    month SMALLINT NOT NULL,
    day SMALLINT NOT NULL,
    hour SMALLINT NOT NULL,
    temp NUMERIC(5,2),
    dewp NUMERIC(5,2),
    humid NUMERIC(5,2),
    wind_dir SMALLINT,
    wind_speed NUMERIC(10,5),
    wind_gust NUMERIC(10,5),
    precip NUMERIC(5,3),
    pressure NUMERIC(7,2),
    visib NUMERIC(5,2),
    time_hour TIMESTAMP NOT NULL,
    PRIMARY KEY (origin, time_hour)
);

CREATE TABLE flights (
    year SMALLINT NOT NULL,
    month SMALLINT NOT NULL,
    day SMALLINT NOT NULL,
    dep_time SMALLINT,
    sched_dep_time SMALLINT,
    dep_delay SMALLINT,
    arr_time SMALLINT,
    sched_arr_time SMALLINT,
    arr_delay SMALLINT,
    carrier CHAR(2), -- временно без внешнего ключа
    flight INTEGER,
    tailnum VARCHAR(6), -- временно без внешнего ключа
    origin CHAR(3), -- временно без внешнего ключа
    dest CHAR(3),   -- временно без внешнего ключа
    air_time SMALLINT,
    distance INTEGER,
    hour SMALLINT,
    minute SMALLINT,
    time_hour TIMESTAMP
);

-- Загружаем CSV (NA → NULL)
\copy airlines FROM 'data/airlines.csv' WITH (FORMAT csv, HEADER true, NULL 'NA');
\copy airports FROM 'data/airports.csv' WITH (FORMAT csv, HEADER true, NULL 'NA');
\copy planes FROM 'data/planes.csv' WITH (FORMAT csv, HEADER true, NULL 'NA');
\copy weather FROM 'data/weather.csv' WITH (FORMAT csv, HEADER true, NULL 'NA');
\copy flights FROM 'data/flights.csv' WITH (FORMAT csv, HEADER true, NULL 'NA');

-- После успешной загрузки можно добавить внешние ключи
ALTER TABLE flights
    ADD CONSTRAINT flights_carrier_fkey FOREIGN KEY (carrier) REFERENCES airlines(carrier),
    ADD CONSTRAINT flights_tailnum_fkey FOREIGN KEY (tailnum) REFERENCES planes(tailnum),
    ADD CONSTRAINT flights_origin_fkey FOREIGN KEY (origin) REFERENCES airports(faa),
    ADD CONSTRAINT flights_dest_fkey FOREIGN KEY (dest) REFERENCES airports(faa);
