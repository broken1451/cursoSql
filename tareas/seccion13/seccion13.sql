select * from public.posts p where p.post_id = 1;

select
    date_trunc('year', created_at) as weeks,
    count(*)
from public.posts p
GROUP by weeks
order by weeks desc;

-- vistas
create or replace view public.comments_per_week as(
    select
        date_trunc('week', a.created_at) as weeks,
        sum(b.counter) as total_claps,
        count(*) as number_claps,
        count(distinct a.post_id) as number_of_post
    from public.posts a
        inner join public.claps b on b.post_id = a.post_id
    GROUP by weeks
    order by weeks desc
)
-- vistas

create
or replace view public.comments_per_week as
select
    date_trunc('week', a.created_at) as weeks,
    sum(b.counter) as total_claps,
    count(*) as number_claps,
    count(distinct a.post_id) as number_of_post
from public.posts a
    inner join public.claps b on b.post_id = a.post_id
GROUP by weeks
order by weeks desc;

-- vista tradicional, se usan para ahorrarse escribir querys muy complejos si es una tarea muy comun, las vista no resume, no lo almacena en memoria es la forma de asignarle un alias a un query
select * from public.comments_per_week cpw;
drop view public.comments_per_week;
select * from public.claps where post_id = 1

-- vistas materializadas
create MATERIALIZED view
    public.comments_per_week_mat1 as
select
    date_trunc('week', a.created_at) as weeks,
    sum(b.counter) as total_claps,
    count(*) as number_claps,
    count(distinct a.post_id) as number_of_post
from public.posts a
    inner join public.claps b on b.post_id = a.post_id
GROUP by weeks
order by weeks desc;

select * from public.posts p where p.post_id = 252;

select * from public.comments_per_week cpw;

select * from public.comments_per_week_mat1 cpwm;

-- actualizar vista materializada

refresh materialized view public.comments_per_week_mat1;

--------------
-- (Common Table Expressions) tabla virtual en memoria con ese resultado, y se le le puede aplicar otras consultas 
SELECT date_trunc('week'::text, posts.created_at) AS weeks,
    sum(claps.counter) AS total_claps,
    count(DISTINCT posts.post_id) AS number_of_posts,
    count(*) AS number_of_claps
   FROM posts
     JOIN claps ON claps.post_id = posts.post_id
  GROUP BY (date_trunc('week'::text, posts.created_at))
  ORDER BY (date_trunc('week'::text, posts.created_at)) DESC;


-- es para simplificar nuestra querys
select * from  public.post_per_week ppw;

with posts_week_2024_with as (
	SELECT date_trunc('week'::text, posts.created_at) AS weeks,
	    sum(claps.counter) AS total_claps,
	    count(DISTINCT posts.post_id) AS number_of_posts,
	    count(*) AS number_of_claps
	   FROM posts
	     JOIN claps ON claps.post_id = posts.post_id
	  GROUP BY (date_trunc('week'::text, posts.created_at))
	  ORDER BY (date_trunc('week'::text, posts.created_at)) DESC
) 
select * from posts_week_2024_with 
where weeks  between '2024-01-01' and '2024-12-31' and total_claps >= 600;


-- in  # Exista en 
with claps_per_post as(
	select c.post_id, sum(c.counter)  from public.claps c
	GROUP by post_id
), post_from_2023 as (
	select * from public.posts p where  created_at between '2023-01-01' and '2023-12-31'
)
select * from claps_per_post  
where claps_per_post.post_id in (select post_id from post_from_2023);

-- (Common Table Expressions) recursivos
-- nombre de la tabla en memoria
-- campos qye vamos a tener
-- with recursive countdown(campo1,campo2,campo3)  as (
with recursive countdown(val)  as (
	-- initializacion => valores iniciales o el primer nivel
	-- select 5 or values(5)
	-- values(5) -- el val toma el valor de 5
	select 5 as val
union
	-- query recursivo
	select val - 1 from countdown where val > 1
)
--select de los campos  se puede seleccionar estos campos aca with recursive countdown(campo1,campo2,campo3)  as 
-- select campo1,campo2,campo3
select * from countdown;


with recursive contador(val)  as (
	-- initializacion => valores iniciales o el primer nivel
	select 1 as val
union
	-- query recursivo
	select val + 1 from contador where val < 10
)
select * from contador;



with recursive tablaMultiplicar5(base, val, resultado) as (
    -- inicialización => valores iniciales o el primer nivel
    select 5 as base, 1 as val, 5 as resultado
    union
    -- query recursivo
    select 5 as base, val + 1, (val +1) *  base from tablaMultiplicar5
    	where val < 10
)
select * from tablaMultiplicar5;

with recursive tablaMultiplicar as (
    -- inicialización => valores iniciales o el primer nivel
    select 5 as base, 1 as repeticion, 5 as resultado_mul 
    union
    -- query recursivo
    select 5 as base , repeticion + 1, (repeticion + 1) * base
    from tablaMultiplicar
    where repeticion < 10 
)
select * from tablaMultiplicar;

select * from public.employees e;
-- query recursivo manual 
select  * from public.employees e  where e.reports_to = 1
union
select  * from public.employees e  where e.reports_to in (2,3)
union 
select  * from public.employees e  where e.reports_to in (6,4,5);

with recursive bosses as (
	-- init
	select e.id, e.name, e.reports_to, 1 as profundidad from public.employees e where e.id = 1
	union
	-- query recursive
	select e.id, e."name", e.reports_to, profundidad + 1 from public.employees e 
	join bosses on bosses.id = e.reports_to
	where  profundidad < 4 -- se recomienda poner un limite en la profundidad de la recursividad
)
select * from bosses 
where  profundidad <= 4;  -- no es recomendable hacer esto acarrea problemas de performance



with recursive bosses as (
	-- init
	select e.id, e.name, e.reports_to, 1 as profundidad from public.employees e where e.id = 1
	union
	-- query recursive
	select e.id, e."name", e.reports_to, profundidad + 1 from public.employees e 
	join bosses on bosses.id = e.reports_to
	--where  profundidad < 4
)
select bosses.*, public.employees."name" as name_report from bosses 
left join  public.employees on  public.employees.id = bosses.reports_to
where  profundidad <= 4;



with recursive bosses as (
	-- init
	select e.id, e.name, e.reports_to, 1 as profundidad from public.employees e where e.id = 1
	union
	-- query recursive
	select e.id, e."name", e.reports_to, profundidad + 1  from public.employees e 
	join bosses on bosses.id = e.reports_to
	--where  profundidad < 4
)
select bosses.*, e.name as report_name from bosses
left join public.employees e on bosses.reports_to = e.id;

with recursive bosses as (
	-- init
	select e.id, e.name, e.reports_to, 1 as profundidad from public.employees e where e.id = 1
	union
	-- query recursive
	select e.id, e."name", e.reports_to, profundidad + 1  from public.employees e 
	join bosses on bosses.id = e.reports_to
	--where  profundidad < 4
)
select * from bosses
left join public.employees e on bosses.reports_to = e.id;

with recursive bosses as (
	-- init
	select e.id, e.name, e.reports_to, 1 as profundidad from public.employees e where e.reports_to  is null
	union
	-- query recursive
	select e.id, e."name", e.reports_to, profundidad + 1  from public.employees e 
	join bosses on bosses.id = e.reports_to
    where  profundidad < 2
)
select * from bosses
left join public.employees e on bosses.reports_to = e.id 
order by profundidad ASC;


select * from public.followers f;


SELECT a.id, c."name", b.name
FROM public.followers a
JOIN public."user" b ON b.id = a.leader_id 
JOIN public."user" c ON c.id  = a.follower_id  



select * from public.followers f;


SELECT a.id, c."name", b.name
FROM public.followers a
JOIN public."user" b ON b.id = a.leader_id 
JOIN public."user" c ON c.id  = a.follower_id  


select * from public.followers f  where leader_id  = 1
union
select  * from public.followers  where leader_id in (2,3)
select  * from public.followers  where leader_id in (select follower_id  from public.followers  where leader_id  = 1)