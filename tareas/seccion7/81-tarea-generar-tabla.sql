

-- Count Union - Tarea
-- Total |  Continent
-- 5	  | Antarctica
-- 28	  | Oceania
-- 46	  | Europe
-- 51	  | America
-- 51	  | Asia
-- 58	  | Africa
(select count(*) as count, b."name" from country a
INNER join continent b on a.continent = b.code
WHERE b."name" NOT LIKE '%America%'
group by b."name")
union 
SELECT SUM(count) AS count, 'America' as name
FROM (
    SELECT COUNT(*) AS count, b."name" as name
    FROM country a
    INNER JOIN continent b ON a.continent = b.code
    WHERE b."name" LIKE '%America%'
    GROUP BY b."name"
) subquery order by count asc;


(select count(*) as count, b."name" from country a
INNER join continent b on a.continent = b.code
WHERE b."name" NOT LIKE '%America%'
group by b."name")
union 
(SELECT COUNT(*) AS count, 'America'
FROM country a
INNER JOIN continent b ON a.continent = b.code
WHERE b."name" LIKE '%America%') order by count asc;



(select count(*) as count, b."name" from country a
INNER join continent b on a.continent = b.code
WHERE b.code in (1,2,3,5,7,9,10,11)
group by b."name")
union 
(SELECT COUNT(*) AS count, 'America'
FROM country a
INNER JOIN continent b ON a.continent = b.code
WHERE b.code in (4,6,8)
) order by count asc;


-- tarea de cuantas ciudades hay en un pais
select  * from country c;
select  * from city c where  countrycode  = 'NLD';

select count(*) as total_ciudades, c."name" from country c
INNER join city c2 on c.code = c2.countrycode
GROUP by c."name"
order by total_ciudades desc;