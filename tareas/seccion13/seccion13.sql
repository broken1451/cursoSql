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