select a.country_id, a.country_name, b.region_name  from public.countries a
join public.regions b on a.region_id = b.region_id;

select  * from regions r;

-- Funcion que retorna una tabla
create or replace FUNCTION public.country_region()
    RETURNS TABLE(
        ID CHARACTER(2),
        NAME VARCHAR(40),
        REGION VARCHAR(25)
    )  AS $$
BEGIN
    RETURN QUERY 
        select a.country_id, a.country_name, b.region_name  from public.countries a
        join public.regions b on a.region_id = b.region_id;
END;
$$ LANGUAGE plpgsql;  
    
select  * from public.country_region();

 -- procedicminetos almacenados, no necesariamente regresa algo
CREATE OR REPLACE PROCEDURE public.insert_region_proc(int, varchar)
as $$
-- declare
begin
	raise notice  'Variable 1: %, %', $1, $2;
    insert into public.regions(region_id, region_name) values($1, $2);
   -- ROLLBACK; -- revertir cambios;
   commit; -- impacta la bd con todo lo q tenga check, validaciones, etc
END;
$$ LANGUAGE plpgsql;

call public.insert_region_proc(5, 'Central america2');
select * from regions;

----------- 2 ------------
-- -------------------------------------------------------------
-- TablePlus 5.3.8(500)
--
-- https://tableplus.com/
--
-- Database: vivo
-- Generation Time: 2023-07-29 12:44:25.9870
-- -------------------------------------------------------------


DROP TABLE IF EXISTS "public"."raise_history";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS raise_history_id_seq;

-- Table Definition
CREATE TABLE "public"."raise_history" (
    "id" int4 NOT NULL DEFAULT nextval('raise_history_id_seq'::regclass),
    "date" date,
    "employee_id" int4,
    "base_salary" numeric(8,2),
    "amount" numeric(8,2),
    "percentage" numeric(4,2),
    PRIMARY KEY ("id")
);


CREATE OR REPLACE FUNCTION max_raise( empl_id int )
returns NUMERIC(8,2) as $$

DECLARE
	possible_raise NUMERIC(8,2);

BEGIN
	
	select 
		max_salary - salary into possible_raise
	from employees
	INNER JOIN jobs on jobs.job_id = employees.job_id
	WHERE employee_id = empl_id;

	if ( possible_raise < 0 ) THEN
		possible_raise = 0;
	end if;

	return possible_raise;

END;
$$ LANGUAGE plpgsql;

select 
	public.max_raise(a.employee_id),
	a.salary, 
	a.job_id  
from 
	employees a;
select  * from jobs where job_id =4;

select 
	current_date as "date",
	public.max_raise(a.employee_id),
	a.salary,
	public.max_raise(a.employee_id) * 0.01 as aumento,
	public.max_raise(a.employee_id) * 0.01 + a.salary as total
from 
	employees a;

select
    current_date as "date",
    public.max_raise(a.employee_id),
    a.salary,
    public.max_raise(a.employee_id) * 0.05 as amount,
    5 as percentage
from employees a;

select * from raise_history;

CREATE OR REPLACE PROCEDURE controlled_raise_proc(percentage NUMERIC)
as $$
DECLARE
    raise NOTICE 'POERCENTAJE A AUMENTAR'
BEGIN

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE controlled_raise_proc(percentage NUMERIC)
as $$
declare
	amount numeric;
	real_percentaje numeric;
	total_employees int;
begin
	-- raise NOTICE 'POERCENTAJE A AUMENTAR %', percentage;
	real_percentaje = percentage / 100;	
	
    -- mantener el historial de los aumentos
    insert into  public.raise_history(
            date,
            employee_id,
            base_salary,
            amount,
            percentage
        )
    select
        current_date as "date",
        a.employee_id,
        a.salary,
        public.max_raise(a.employee_id) * real_percentaje as amount,
        percentage from employees a;
    -- impactar los la base de datos con los aumentos
    update 
        public.employees 
    set 
        salary = salary + (public.max_raise(a.employee_id) * real_percentaje);

COMMIT;
    SELECT count(*) FROM public.employees into total_employees;
	raise NOTICE 'AFECTADOS % EMPLEADOS', total_employees;


END;
$$ LANGUAGE plpgsql; 

call public.controlled_raise_proc(3)

select
    current_date as "date",
    a.employee_id,
    a.salary,
    public.max_raise(a.employee_id) * 0.05 as amount,
    5 as percentage
from employees a;

-------- 3
CREATE OR REPLACE PROCEDURE controlled_raise_proc(percentage NUMERIC)
as $$
declare
	amount numeric;
	real_percentaje numeric;
	total_employees int;
    datecurrent current_date;
begin
	-- raise NOTICE 'POERCENTAJE A AUMENTAR %', percentage;
	real_percentaje = percentage / 100;	
	
    -- mantener el historial de los aumentos
    insert into  public.raise_history(
            date,
            employee_id,
            base_salary,
            amount,
            percentage
        )
    datecurrent = "2023-12-24"
    select
        current_date as "date",
        a.employee_id,
        a.salary,
        public.max_raise(a.employee_id) * real_percentaje as amount,
        percentage from employees a;
       
    -- impactar los la base de datos con los aumentos
	if ( current_date = current_date ) then
			raise NOTICE 'La fecha actual debe ser diferente';
			raise exception  'Este proceso se ejecuta diariamente y la fecha actual no es diferente';
	else
	  update 
        public.employees a
    set 
        salary = salary + (public.max_raise(a.employee_id) * real_percentaje);

	end if;
       
COMMIT;
    SELECT count(*) FROM public.employees into total_employees;
	raise NOTICE 'AFECTADOS % EMPLEADOS', total_employees;
END;
$$ LANGUAGE plpgsql; 

call public.controlled_raise_proc(1)
select * from raise_history rh;
select  24000.00 * 0.01, public.max_raise(100) 


-------- 4
CREATE OR REPLACE PROCEDURE controlled_raise_proc(percentage NUMERIC)
AS $$
DECLARE
    amount NUMERIC;
    real_percentage NUMERIC;
    total_employees INT;
    datecurrent DATE;
BEGIN
    -- raise NOTICE 'PORCENTAJE A AUMENTAR %', percentage;
    real_percentage := percentage / 100;

    -- mantener el historial de los aumentos
    datecurrent := '2023-12-23';
    INSERT INTO public.raise_history (
        date,
        employee_id,
        base_salary,
        amount,
        percentage
    )
    SELECT
        current_date,
        a.employee_id,
        a.salary,
        public.max_raise(a.employee_id) * real_percentage AS amount,
        percentage
    FROM
        employees a;

    -- impactar la base de datos con los aumentos
    IF (current_date = datecurrent) THEN
        RAISE NOTICE 'La fecha actual debe ser diferente';
        RAISE EXCEPTION 'Este proceso se ejecuta diariamente y la fecha actual no es diferente';
    ELSE
        UPDATE public.employees a
        SET salary = salary + (public.max_raise(a.employee_id) * real_percentage);
    END IF;

    COMMIT;
    SELECT count(*) INTO total_employees FROM public.employees;
    RAISE NOTICE 'AFECTADOS % EMPLEADOS', total_employees;
END;
$$ LANGUAGE plpgsql;

call public.controlled_raise_proc(1)
select * from raise_history rh;
select  24000.00 * 0.01, public.max_raise(100) 