CREATE OR REPLACE FUNCTION great_employee(empl_name varchar)
RETURNS varchar AS $$
-- DECLARE
BEGIN
    RETURN 'Hello ' || empl_name;
END;
$$ LANGUAGE plpgsql;
 
 select * from public.employees;

select greatest(23,3,56) ;
select avg(23); 
select coalesce(null, 'hola mundo');

CREATE OR REPLACE FUNCTION great_employee(empl_name varchar)
RETURNS varchar AS $$
-- DECLARE
BEGIN
    RETURN 'Hello ' || empl_name;
END;
$$ LANGUAGE plpgsql;
 

select first_name,  public.greea_employee(first_name)  from employees e;
select * from public.employees e;
select public.greea_employee('adrian');


SELECT * FROM public.employees e;

SELECT * FROM public.jobs j;

SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    max_salary,
    max_salary - salary as aumento
FROM public.employees a
    JOIN public.jobs b ON a.job_id = b.job_id
where a.employee_id = 206;

CREATE OR REPLACE FUNCTION AUMENTO_SALARIO(EMPL_ID INT) 
RETURNS NUMERIC(8, 2) AS $$ 
	$$
	DECLARE
	    -- salario numeric(8, 2);
	salario_max numeric(8, 2);
	BEGIN
	SELECT -- employee_id,
	-- first_name,
	-- last_name,
	-- salary,
	-- max_salary,
	max_salary - salary into salario_max
	FROM public.employees a
	    JOIN public.jobs b ON a.job_id = b.job_id
	WHERE
	    a.employee_id = empl_id;
	RETURN salario_max;
	END;
	$$ LANGUAGE plpgsql;


select public.aumento_salario(206)


CREATE OR REPLACE FUNCTION AUMENTO_SALARIO2(EMPL_ID INT)
RETURNS NUMERIC(8, 2) AS $$
DECLARE
    employee_job_id int;
    current_salary NUMERIC(8, 2);

    job_max_salary NUMERIC(8, 2);
    possible_aumento numeric(8, 2);
begin
	-- tomar el puesto de trabajo y el salario
    SELECT  job_id, salary 
    into employee_job_id, current_salary
   	from employees WHERE employee_id = EMPL_ID;
   
   -- tomar el ma salary, acorde a su job
   select max_salary into job_max_salary from jobs where job_id = employee_job_id ;
  
   -- calculos 
   possible_aumento =  job_max_salary - current_salary;
   IF (possible_aumento < 0) then
   	-- raise exception 'PERSONA CON SALARIO MAYOR max_salary: %', EMPL_ID o contatenar, el % va a tomar el valor de EMPL_ID
   	raise exception 'PERSONA CON SALARIO MAYOR max_salary: %', EMPL_ID; -- tirar una excepcion
   	-- possible_aumento = 0;
   END IF;
  	 
RETURN possible_aumento;
END;
$$ LANGUAGE plpgsql;

select employee_id, first_name,salary , public.aumento_salario(employee_id), public.AUMENTO_SALARIO2(employee_id) from public.employees where  employee_id = 206;

-- rowtype
CREATE OR REPLACE FUNCTION AUMENTO_SALARIO3(EMPL_ID INT)
RETURNS NUMERIC(8, 2) AS $$
DECLARE
    selected_employee employees%rowtype;
    selected_job jobs%rowtype;
    possible_aumento numeric(8, 2);
begin
	-- tomar el puesto de trabajo y el salario
    SELECT  * from employees into  selected_employee   WHERE employee_id = EMPL_ID;
   
   -- tomar el ma salary, acorde a su job
   select * from jobs into selected_job where job_id = selected_employee.job_id;
  
   -- calculos 
   possible_aumento =  selected_job.max_salary - selected_employee.salary;
   IF (possible_aumento < 0) then
   	-- raise exception 'PERSONA CON SALARIO MAYOR max_salary: %', EMPL_ID o contatenar, el % va a tomar el valor de EMPL_ID
   	raise exception 'PERSONA CON SALARIO MAYOR max_salary: id:%, %',selected_employee.employee_id, selected_employee.first_name; -- tirar una excepcion
   	-- possible_aumento = 0;
   END IF;
  	 
RETURN possible_aumento;
END;
$$ LANGUAGE plpgsql;

select employee_id, first_name,salary , public.aumento_salario(employee_id), public.AUMENTO_SALARIO3(employee_id) from public.employees where  employee_id = 206;