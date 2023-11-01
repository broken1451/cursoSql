-- unions - unir resultados
SELECT * FROM continent;

SELECT * FROM continent WHERE code in(6,8,4);

SELECT * FROM continent WHERE name LIKE '%America%';

SELECT * FROM continent WHERE code in(5,4);


SELECT * FROM continent WHERE name LIKE '%America%'
UNION
SELECT * FROM continent WHERE code in(5,3)
ORDER BY name ASC;

-- para las uniones deben tener la misma cantidad columnas a consultar y el mismo tipo de datos
SELECT code, name, '123' FROM continent WHERE name LIKE '%America%'
UNION
SELECT code, name, 'otra' FROM continent WHERE code in(5,3)
ORDER BY name ASC;

SELECT code, name, '123' FROM continent WHERE name LIKE '%America%'
UNION
SELECT  name, code, 'otra' FROM continent WHERE code in(5,3)
ORDER BY name ASC;

SELECT code, name, '123' FROM continent WHERE name LIKE '%America%' -- todo lo q tenga la palabra america
UNION
SELECT  2, name, 'otra' FROM continent WHERE code in(5,3)
ORDER BY name ASC;

SELECT code, name, '123' FROM continent WHERE name LIKE '%America%' -- todo lo q tenga la palabra america
UNION
SELECT  2, 'otra', name FROM continent WHERE code in(5,3)
ORDER BY name ASC;



-- unions de tablas
SELECT a.name, a.continent, a.* from country a;

-- join con where
-- SELECT a.name, a.continent from tabla1 a, tabla2 b
-- WHERE a.continent = b.code
-- ORDER BY name ASC;
SELECT a.name, a.continent from country a, continent b
WHERE a.continent = b.code
ORDER BY name ASC;

SELECT a.name as country, b.name as continent from country a, continent b
WHERE a.continent = b.code
ORDER BY a.name ASC;

-- JOIN or inner join
SELECT a.name as country, b.name as continent from country a
INNER JOIN continent b on a.continent = b.code
ORDER BY a.name ASC;

SELECT a.name as country, b.name as continent from country a
JOIN continent b on a.continent = b.code
ORDER BY b.name DESC;


-- alteracion de secuenciasc
-- ALTER SEQUENCE 'name_secuencia' RESTART with 8;
ALTER SEQUENCE continent_code_seq RESTART with 8;


-- full OUTER JOIN
SELECT a.name, a.continent FROM country a;
SELECT b.name as contientName FROM continent b;

SELECT a.name as country, a.continent as contientCode, b.name as contientName FROM country a
FULL OUTER JOIN continent b
ON a.continent = b.code order by a."name" desc;

-- RIGHT OUTER JOIN exclusive
SELECT a.name as country, a.continent as contientCode, b.name as contientName FROM country a
RIGHT JOIN continent b
ON a.continent = b.code WHERE a.continent IS null;


-- Aggregations + Joins
select count(*), b."name"  from country a
INNER join continent b on a.continent = b.code 
group by b."name"
order by count(*) asc; 

select count(*), b."name"  from country a
INNER join continent b on a.continent = b.code 
group by b."name"
-- order by count(*) asc; 
UNION
select 0, b."name"  from country a
right join continent b on a.continent = b.code 
where  a.continent is null
group by b."name"
-- order by count(*) asc; 

(select count(*) as count, b."name"  from country a
INNER join continent b on a.continent = b.code 
group by b."name")
UNION
(select 0 as count, b."name"  from country a
right join continent b on a.continent = b.code 
where  a.continent is null
group by b."name")
order by count asc; 



-- tarea de cuantas ciudades hay en un pais
select  * from country c;
select  * from city c where  countrycode  = 'NLD';

select count(*) as total_ciudades, c."name" from country c
INNER join city c2 on c.code = c2.countrycode
GROUP by c."name"
order by total_ciudades desc;





-- Aggregations + Joins - multiples
-- Quiero saber los idiomas oficiales que se hablan por continente
select * from countrylanguage c where isofficial = true;
select * from country;
select * from continent;
select * from countrylanguage;

select distinct a."language", c."name"  from countrylanguage a
inner join country b on a.countrycode = b.code
inner join continent c on c.code  = b.continent 
where a.isofficial = true;

-- Cuantos cuantos idiomas oficiales que se hablan por continente
select count(*) as total, continent from (
	select distinct a."language", c."name" as continent from countrylanguage a
	inner join country b on a.countrycode = b.code
	inner join continent c on c.code  = b.continent 
	where a.isofficial = true
) as totales
group by continent order by total;

select * from "language";

select distinct l."name", c."name"  from countrylanguage a
inner join country b on a.countrycode = b.code
inner join continent c on c.code  = b.continent 
inner join "language" l on l.code = a.languagecode  
where a.isofficial = true;



-- ¿Cuál es el idioma (y código del idioma) oficial más hablado por diferentes países en Europa?

select * from countrylanguage where isofficial = true;

select * from country;

select * from continent;

Select * from "language";

select distinct b."name" , c."name", c.continent  from countrylanguage a 
inner join "language" b on b.code = a.languagecode 
inner join country  c on c.code = a.countrycode  
where isofficial = true and c.continent in (5);


select distinct b."name", c."name", c2."name"  from countrylanguage a 
inner join "language" b on b.code = a.languagecode 
inner join country  c on c.code = a.countrycode  
inner join continent c2  on c2.code = c.continent  
where isofficial = true and c2.name  LIKE '%Europe%';







-- Listado de todos los países cuyo idioma oficial es el más hablado de Europa 
-- (no hacer subquery, tomar el código anterior)






-- ¿Cuál es el idioma (y código del idioma) oficial más hablado por diferentes países en Europa?

select * from countrylanguage where isofficial = true;

select * from country;

select * from continent;

Select * from "language";



select count(*) as conteo, b."name" as continent, c."language" as idioma  from country a
inner join continent b on a.continent = b.code
inner join countrylanguage c on c.countrycode = a.code 
where  b.name LIKE '%Europe%' and c.isofficial = true 
group by b."name", c."language"
order by conteo desc limit 1;

select count(*) as conteo, c."language", c.languagecode as code_idioma from country a
inner join continent b on a.continent = b.code
inner join countrylanguage c on c.countrycode = a.code 
where  b.name LIKE '%Europe%' and c.isofficial = true 
group by c."language", code_idioma
order by conteo desc;




-- Listado de todos los países cuyo idioma oficial es el más hablado de Europa 
-- (no hacer subquery, tomar el código anterior)
select * from country a 
inner join countrylanguage c on c.countrycode = a.code 
where  a.continent = 5 and c.isofficial = true and c.languagecode = 135;