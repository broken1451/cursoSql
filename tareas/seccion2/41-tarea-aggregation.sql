
-- 1. Cuantos usuarios tenemos con cuentas @google.com
-- Tip: count, like
SELECT 
    COUNT(*) as total
FROM 
    users
WHERE email LIKE '%@google.com';

SELECT SUM(total) from
(SELECT 
    COUNT(*) as total,
    email
FROM 
    users
WHERE email LIKE '%@google.com'
GROUP BY email) as total_user_google;


-- 2. De qué países son los usuarios con cuentas de @google.com
-- Tip: distinct
-- SELECT * from users;
SELECT DISTINCT
    country
FROM 
    users
WHERE email LIKE '%@google.com';



-- 3. Cuantos usuarios hay por país (country)
-- Tip: Group by
-- SELECT * from users;
SELECT 
    COUNT(*) as total,
    country
FROM 
    users
GROUP BY country
ORDER BY  country ASC;


-- 4. Listado de direcciones IP de todos los usuarios de Iceland
-- Campos requeridos first_name, last_name, country, last_connection
-- SELECT * from users;
SELECT 
    first_name, last_name, country, last_connection 
from users
WHERE country = 'Iceland';


-- 5. Cuantos de esos usuarios (query anterior) tiene dirección IP
-- que incia en 112.XXX.XXX.XXX
SELECT 
    -- first_name, last_name, last_connection  
    count(*)
from 
    users 
WHERE country = 'Iceland' and last_connection LIKE '112.%';


-- 6. Listado de usuarios de Iceland, tienen dirección IP
-- que inicia en 112 ó 28 ó 188
-- Tip: Agrupar condiciones entre paréntesis 
SELECT 
    first_name, last_name, country, last_connection 
from users
WHERE 
    country = 'Iceland' and (last_connection LIKE '112.%' OR last_connection LIKE '28.%' OR last_connection LIKE '188.%');



-- 7. Ordene el resultado anterior, por apellido (last_name) ascendente
-- y luego el first_name ascendentemente también
SELECT 
    first_name, last_name, country, last_connection 
from users
WHERE country = 'Iceland' and 
    (last_connection LIKE '112.%' OR last_connection LIKE '28.%' OR last_connection LIKE '188.%')
ORDER BY  first_name ASC, last_name ASC;

SELECT 
    first_name, last_name, country, last_connection 
from users
WHERE country = 'Iceland' and 
    (last_connection LIKE '112.%' OR last_connection LIKE '28.%' OR last_connection LIKE '188.%')
ORDER BY  last_name ASC;



-- 8. Listado de personas cuyo país está en este listado
-- ('Mexico', 'Honduras', 'Costa Rica')
-- Ordenar los resultados de por País asc, Primer nombre asc, apellido asc
-- Tip: Investigar IN
-- Tip2: Ver Operadores de Comparación en la hoja de atajos (primera página)
SELECT 
    *
from users
WHERE country IN ('Mexico', 'Honduras', 'Costa Rica')
ORDER BY country ASC;

SELECT 
    *
from users
WHERE country IN ('Mexico', 'Honduras', 'Costa Rica')
ORDER BY first_name ASC;

SELECT 
    *
from users
WHERE country IN ('Mexico', 'Honduras', 'Costa Rica')
ORDER BY last_name ASC;


-- 9. Del query anterior, cuente cuántas personas hay por país
-- Ordene los resultados por País asc
-- SELECT 
--     *
-- from users
-- WHERE country IN ('Mexico', 'Honduras', 'Costa Rica');
SELECT 
  COUNT(*),
  country 
from users
WHERE country IN ('Mexico', 'Honduras', 'Costa Rica')
GROUP BY country;
