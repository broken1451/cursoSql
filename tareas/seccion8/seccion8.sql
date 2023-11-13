SELECT 'adrian' as nombre;


SELECT 
(SELECT count(*) FROM employees e ) as empleados,
(SELECT sum(salary) FROM employees e2 ) as salario;


-- funciones basicas de fechas
select  now(),
		current_date,
		current_time,
		current_user,
		date_part('hour', now()) as hora,
		date_part('minute', now()) as minutos,
		date_part('second', now()) as segundos,
		date_part('day', now()) as dia,
		date_part('month', now()) as mes,
		date_part('year', now()) as anio;

-- consultas sobre fecha
select 
	*
from  
	employees e
where 
	hire_date > '1998-02-05'
order by hire_date desc;

select 
	*
from  
	employees e
where 
	hire_date > date('1998-02-05')
order by hire_date desc;



select 
	max(hire_date) as nuevo_empleado,
	min(hire_date) as antiguo_empleado
from  
	employees e;


select 
	*
from  
	employees e
where 
	hire_date between '1999-01-01' and '2000-01-01'
order by hire_date desc;




-- intervalos
select  max(hire_date)  from employees e;
select  max(hire_date) + 1  from employees e;

select  
	max(hire_date),
	max(hire_date) + 1,
	max(hire_date) + interval '1 day',
	max(hire_date) + interval '1 month',
	max(hire_date) + interval '1 year',
	max(hire_date) + interval '1.1 year', -- un anio mas un mes
	max(hire_date) + interval '1.1 year' + interval '1 day', -- un anio mas un mes mas un dia
	max(hire_date) + interval '1 year' + interval '1 day',
	date_part('year', now()),
	-- 	make_interval(years := valor) 
	make_interval(years := 23), 
	make_interval(years := date_part('year', now())::integer),
	max(hire_date) + make_interval(years := 23),
	max(hire_date) + make_interval(YEARS := ( date_part('years', now())::integer))
from employees e;


-- diferencias entre fechas y actualizaciones
select 
	hire_date,
	make_interval(years := 2023 - extract(years from hire_date)::integer) as manual, -- extrae la cantidad de anios, el intervalo de anios q lleva en la empresa
	make_interval(years := date_part('year', current_date)::integer - extract(years from hire_date)::integer) as programado,
	hire_date + interval '23 year' as fecha_sumada
from employees e
order by hire_date desc;

UPDATE 
	employees 
SET 
	hire_date = hire_date + interval '23 year' 


-- clausula case -then
select 
	first_name, 
	last_name, 
	hire_date as fecha,
	hire_date > now() - interval '1 year' as fecha2,
	 now() - interval '1 year' as fecha3,
	 hire_date > now() - interval '3 year' as fecha5,
	 now() - interval '3 year' as fecha4,
	 -- el case al menos necesita una condicion
	case 
		when hire_date > (now() - interval '1 year') then '1 año o menos'
		when hire_date > (now() - interval '3 year') then '1 a 3 años'
		when hire_date > (now() - interval '6 year') then '3 a 6 años'
		else '+ de 6 años'
	end as rango_antiguedad
from 
	employees
ORDER BY  first_name ASC; 
