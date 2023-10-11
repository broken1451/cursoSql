-- Creacion de tablas

create table users ( name varchar(10) unique );

create table
    users2 (
        name varchar(10) unique,
        apellido varchar unique
    );

-- insertar

-- INSERT INTO "table_name"

--  ("column1", "column2", "column3", ...)

-- VALUES

--  ("value1", "value2", "value3", ...);

-- -- Múltiples

-- INSERT INTO "table_name"

--  ("column1", "column2", "column3", …)

-- VALUES

--  ("value1", "value2", "value3", ...),

--  ("value1", "value2", "value3", ...),

--  ("valuue"),

INSERT into "course-db".public.users values('Bravo1');

INSERT into users values('Bravo');

INSERT into users values('Bravo');

-- todas las columnas

insert into
    "course-db".public.users ("name")
values ('test') -- por columna

-- update
UPDATE "users"
SET
    "name" = 'test' -- columna a actualizar
WHERE "name" = 'Chr';

-- seleccion
SELECT * FROM public.users;

SELECT * FROM users;

SELECT * FROM public.users LIMIT 2 OFFSET 3; -- OFFSET saltate los siguientes 3

-- clausula where
SELECT * FROM public.users WHERE name = 'bravo';

-- Nombre inicie con J mayúscula
WHERE "name" LIKE 'J%';

-- Nombre inicie con Jo
WHERE "name" LIKE 'Jo%';

-- Nombre termine con hn
-- WHERE "name" LIKE '%hn';


-- Nombre tenga 3 letras y las últimas 2
-- tienen que ser "om"
WHERE "name" LIKE '_om'; // Tom 

-- Puede iniciar con cualquier letra
-- seguido de "om" y cualquier cosa después %
WHERE "name" LIKE '_om%'; // Tomas 

SELECT * FROM public.users WHERE name LIKE '_r%';


-- delete
DELETE  FROM public.users WHERE name LIKE '_r%';


-- drop - vs truncate
-- mandar todo a la chingada con drop
DROP TABLE users 

-- truncate - borra sus registros se purgan los datos
TRUNCATE TABLE users;

-- operadores de string y positions
SELECT id, UPPER(name), name FROM users;

SELECT id, LOWER(name), name FROM users;

SELECT id, UPPER(name) as upper_name, name FROM users; -- as es alias

SELECT
    id,
    LOWER(name) as lower_name,
    LENGTH(name),
    name
FROM users; -- El lenght de caracter

SELECT
    id,
    LOWER(name) as lower_name,
    LENGTH(name), (20 * 2) as constante,
    name
FROM users;

SELECT
    id,
    LOWER(name) as lower_name,
    LENGTH(name), (20 * 2) as constante,
    CONCAT(id, '-', name),
    name
FROM users;

SELECT
    id,
    LOWER(name) as lower_name,
    LENGTH(name), (20 * 2) as constante,
    CONCAT(id, '-', name),
    id || '-' || name as concat2,
    name
FROM users;

SELECT name, SUBSTRING(name, 0, 5), POSITION(' ' IN name) FROM users;

SELECT
    name,
    SUBSTRING(name, 0, 5),
    POSITION(' ' IN name),
    SUBSTRING(name, 0, POSITION(' ' IN name)) as first_name,
    POSITION(' ' IN name) as last_name
FROM users;

SELECT
    name,
    SUBSTRING(name, 0, 5),
    POSITION(' ' IN name) as position2,
    SUBSTRING(name, 0, POSITION(' ' IN name)) as first_name,
    SUBSTRING(name, POSITION(' ' IN (name)) + 1) as last_name,
    TRIM( SUBSTRING(name, POSITION(' ' IN (name)))) as last_name_trim
FROM users;

SELECT * FROM users;

UPDATE users
SET
    first_name = SUBSTRING(name, 0, POSITION(' ' IN name)),
    last_name = SUBSTRING(name, POSITION(' ' IN (name)) + 1)