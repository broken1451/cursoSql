

-- Tarea con countryLanguage

-- Crear la tabla de language

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS language_code_seq;


-- Table Definition
CREATE TABLE "public"."language" (
    "code" int4 NOT NULL DEFAULT 	nextval('language_code_seq'::regclass),
    "name" text NOT NULL,
    PRIMARY KEY ("code")
);

-- Crear una columna en countrylanguage
ALTER TABLE countrylanguage
ADD COLUMN languagecode varchar(3);


-- Empezar con el select para confirmar lo que vamos a actualizar
SELECT code, "name"
FROM public."language";

SELECT countrycode, "language", isofficial, percentage, languagecode
FROM public.countrylanguage;
select distinct "language" from countrylanguage;

insert into "language" (name) select distinct cl."language" from countrylanguage cl;

-- Actualizar todos los registros
select 
	"language",
	languagecode,
	(select l."name" from "language" l where l.name  = c2.language)
from countrylanguage c2;

update 
	countrylanguage a
set languagecode  = (select l.code  from "language" l where l.name  = a.language);

-- Cambiar tipo de dato en countrylanguage - languagecode por int4
alter table countrylanguage  
alter column languagecode type int4 USING languagecode::integer;

-- Crear el forening key y constraints de no nulo el language_code
ALTER TABLE public.countrylanguage ADD CONSTRAINT countrylanguage_fk FOREIGN KEY (languagecode) REFERENCES language(code);

-- Revisar lo creado
select  * from  countrylanguage c;
