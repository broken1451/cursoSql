

-- ¿Cuál es el idioma (y código del idioma) oficial más hablado por diferentes países en Europa?

select * from countrylanguage where isofficial = true;

select * from country;

select * from continent;

Select * from "language";







-- Listado de todos los países cuyo idioma oficial es el más hablado de Europa 
-- (no hacer subquery, tomar el código anterior)



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


----------------------------------------------------------------------------------
-- ¿Cuál es el idioma (y código del idioma) oficial más hablado por diferentes países en Europa?

select * from countrylanguage where isofficial = true;

select * from countrylanguage;

select * from country;

select * from continent;

select * from "language";

LIKE '%Europe%'


select count(*) as count, a."language" as idioma, b.code as code_idioma, c.continent as contienente, c2."name"  from countrylanguage a 
join "language" b on b.code = a.languagecode  
join  country c on c.code = a.countrycode  
join  continent c2 on c2.code = c.continent  
where isofficial = true and c2.name LIKE '%Europe%'
group by  idioma,code_idioma, contienente, c2."name"
order by count desc limit 1;

select count(*) as count, a."language" as idioma, b.code as code_idioma, c.continent as contienente, c2."name"  from countrylanguage a 
join "language" b on b.code = a.languagecode  
join  country c on c.code = a.countrycode  
join  continent c2 on c2.code = c.continent  
where isofficial = true and c2.name LIKE '%Europe%'
group by  idioma,code_idioma, contienente, c2."name"
order by count desc;



-- Listado de todos los países cuyo idioma oficial es el más hablado de Europa 
-- (no hacer subquery, tomar el código anterior)
select  * from country c 
join continent c2 on c2.code = c.continent
join countrylanguage c3 on c3.countrycode = c.code
where  c3.isofficial = true and c2.name LIKE '%Europe%' and c3.languagecode = 135;


select  * from country c 
join continent c2 on c2.code = c.continent
join countrylanguage c3 on c3.countrycode = c.code
where  c3.isofficial = true and c2.name LIKE '%Europe%' and c3.languagecode = (select code_idioma from (
	select count(*) as count, a."language" as idioma, b.code as code_idioma, c.continent as contienente, c2."name"  from countrylanguage a 
	join "language" b on b.code = a.languagecode  
	join  country c on c.code = a.countrycode  
	join  continent c2 on c2.code = c.continent  
	where isofficial = true and c2.name LIKE '%Europe%'
	group by  idioma,code_idioma, contienente, c2."name"
	order by count desc limit 1
) as idioma
group  by code_idioma
)






