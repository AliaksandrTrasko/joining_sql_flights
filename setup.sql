\encoding UTF8

-- Устанавливаем стиль для дат, чтобы избежать ошибок при импорте
SET datestyle TO 'ISO, MDY';

-- Удаляем таблицы, если они уже существуют, чтобы скрипт можно было запускать несколько раз
DROP TABLE IF EXISTS airlines, airports, planes, weather, flights;

-- Создание таблицы АВИАКОМПАНИИ
CREATE TABLE airlines (
    carrier CHAR(2) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Создание таблицы АЭРОПОРТЫ
CREATE TABLE airports (
    faa CHAR(3) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    lat NUMERIC(10, 7) NOT NULL,
    lon NUMERIC(10, 7) NOT NULL,
    alt INTEGER NOT NULL,
    tz INTEGER NOT NULL,
    dst CHAR(1) NOT NULL,
    tzone VARCHAR(255)
);

-- Создание таблицы САМОЛЕТЫ
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

-- Создание таблицы ПОГОДА
CREATE TABLE weather (
    origin CHAR(3) NOT NULL,
    year SMALLINT NOT NULL,
    month SMALLINT NOT NULL,
    day SMALLINT NOT NULL,
    hour SMALLINT NOT NULL,
    temp NUMERIC(5, 2),
    dewp NUMERIC(5, 2),
    humid NUMERIC(5, 2),
    wind_dir SMALLINT,
    wind_speed NUMERIC(6, 3),
    wind_gust NUMERIC(6, 3),
    precip NUMERIC(5, 3),
    pressure NUMERIC(7, 2),
    visib NUMERIC(5, 2),
    time_hour TIMESTAMP NOT NULL,
    PRIMARY KEY (origin, time_hour) -- Составной первичный ключ
);

-- Создание главной таблицы РЕЙСЫ
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
    carrier CHAR(2) REFERENCES airlines(carrier), -- Внешний ключ к airlines
    flight INTEGER,
    tailnum VARCHAR(6) REFERENCES planes(tailnum), -- Внешний ключ к planes
    origin CHAR(3) REFERENCES airports(faa), -- Внешний ключ к airports
    dest CHAR(3) REFERENCES airports(faa), -- Внешний ключ к airports
    air_time SMALLINT,
    distance INTEGER,
    hour SMALLINT,
    minute SMALLINT,
    time_hour TIMESTAMP
);

--- КОМАНДЫ ДЛЯ ЗАГРУЗКИ ДАННЫХ ---
-- ВАЖНО: Мы используем \copy, а не COPY.
-- \copy - это команда psql-клиента, она читает файл с твоего компьютера.
-- COPY - это команда SQL-сервера, она ищет файл на сервере, что часто вызывает ошибки с доступом.

\copy airlines FROM 'airlines.csv' WITH (FORMAT csv, HEADER true);
\copy airports FROM 'airports.csv' WITH (FORMAT csv, HEADER true);
\copy planes FROM 'planes.csv' WITH (FORMAT csv, HEADER true);
\copy weather FROM 'weather.csv' WITH (FORMAT csv, HEADER true);
\copy flights FROM 'flights.csv' WITH (FORMAT csv, HEADER true);