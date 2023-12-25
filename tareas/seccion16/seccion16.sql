-- triggers
create extension pgcrypto;

INSERT INTO public."user" (username, password) 
VALUES ('melissa', crypt('123456', gen_salt('bf')));

select * from "user" where username = 'broken1451' and "password"=crypt('123456',password) ;

select  count(*) as found, id, username, "password"  from "user" where username = 'broken1451' and "password"=crypt('123456',password) 
group by id, username, "password";

CREATE OR REPLACE PROCEDURE user_login(name_user varchar, user_password varchar)
as $$ 
declare 
	was_found bool;
begin
	select  count(*) into was_found from "user" where username = name_user and "password"=crypt(user_password,password);
	
	if (was_found = false) then
		INSERT INTO public.session_fail (username, "when") values(name_user, now());
		commit;
		raise exception 'Usiario  y clave no son correctos %, %', name_user, user_password; -- al hacer una excepcion hace un rollack y devuelve todo los cambios antes de tira run excepcion hay q hacer un commit
	end if;

	raise notice 'Usiario encontrado %',  was_found;
	update "user" set last_login = now() where username = name_user;
    COMMIT;
end;
$$ language  plpgsql;
call public.user_login('broken1451','123456 ');

select * from "user" u;


CREATE or REPLACE TRIGGER user_login_trigger  AFTER UPDATE ON public."user" FOR EACH ROW WHEN ( OLD.last_login IS DISTINCT FROM NEW.last_login ) EXECUTE FUNCTION public.create_sesson_log();

CREATE OR REPLACE FUNCTION public.create_sesson_log()
RETURNS trigger as $$
declare 

    BEGIN
        INSERT INTO public."session" (user_id, last_login) values(new.id, now()); -- new.id hace referenca a public user, tambn puede ser con otros campos de la tabla
        return new;
    END;
$$ language plpgsql;
    
call public.user_login('broken1451','123456');