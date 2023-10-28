-- creando llave primarias manualmente mediante codigo

select * from country;

DELETE FROM country WHERE code='NLD' AND code2='NA';

-- agregar una llave PRIMARY KEY

alter table country add primary key (code) 

-- agregar un CONSTRAINT CHECK es sencillamente verificaciones que queremos hacer sobre un campo en particular o varios camppos

alter table country ADD CHECK( surfacearea >=0 );

-- agregar un CONSTRAINT CHECK es sencillamente verificaciones que queremos hacer sobre un campo en particular o varios campos(multiples)

alter table country ADD CHECK( 
    (continent = 'Asia'::text) or -- que tipo de dato ::text
    (continent = 'South America') or
    (continent = 'North America') or 
    (continent = 'Antarctica') or 
    (continent = 'Africa') or
    (continent = 'Europe') or 
    (continent = 'Oceania')
);

ALTER table country DROP CONSTRAINT "country_continent_check"

alter table country ADD CHECK( 
    (continent = 'Asia'::text) or -- que tipo de dato ::text
    (continent = 'South America') or
    (continent = 'North America') or 
    (continent = 'Antarctica') or 
    (continent = 'Africa') or
    (continent = 'Europe') or 
    (continent = 'Oceania') or
    (continent) = 'Central America'
);


-- Indices son para tener un control de donde buscar especificamente en la bd de manera mas ordenada
create unique index "unique_country_name" on country(
    name
);

create index "country_continent" on country(
    continent
);


CREATE UNIQUE INDEX "unique_name_countrycode_district" on city(
   name,countrycode,district
)

CREATE INDEX "index_district" on city(
    district
)


-- llaves foraneas haciendo relaciones
ALTER TABLE city
ADD CONSTRAINT fk_countrycode 
FOREIGN KEY (countrycode) REFERENCES country (code) ON DELETE CASCADE; 


ALTER TABLE countrylanguage
ADD CONSTRAINT fk_countrycode 
FOREIGN KEY (countrycode) REFERENCES country (code) 
ON DELETE CASCADE
ON UPDATE CASCADE; 

INSERT INTO country
		values('AFG', 'Afghanistan', 'Asia', 'Southern Asia', 652860, 1919, 40000000, 62, 69000000, NULL, 'Afghanistan', 'Totalitarian', NULL, NULL, 'AF');


-- borrar en cascada
select  *  from  country;
delete from  country where code = 'AFG';
select  * from  country where code = 'AFG';
select  * from  countrylanguage;
select  * from  city where countrycode = 'AFG';
