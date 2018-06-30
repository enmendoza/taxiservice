/*
  Proyecto	: Servicio de Taxi
  Fecha		: 19.05.2018
  Autor		: Enrique Nuñez
  Descripcion	: Esta base de datos contiene toda la informacion de los servicios de taxi
		  que se toman, asi como de los conductores, automoviles y clientes y 
		  demas registros involucrados para llevar un control basico.
*/

-- creando la base de datos
-- create database "taxiservice" with encoding="UTF8" owner="postgres" connection limit=-1;

-- creando la tabla
create table conductor(
  idconductor	integer not null,
  tdoc		character(3) not null,
  ndoc		character varying(12) not null,
  nlicencia	character varying(12) not null,
  nombre	character varying(80) not null,
  direccion	character varying(80) not null,
  telefono	character varying(25) not null,
  constraint pk_conductor_idconductor primary key(idconductor),
  constraint uq_conductor_tdoc_ndoc unique(tdoc,ndoc),
  constraint uq_conductor_nlconducir unique(nlicencia)
);

-- creando funcion
create or replace function fn_conductor(
  idconductor_ integer,
  tdoc_ character varying,
  ndoc_ character varying, 
  nlicencia_ character varying,
  nombre_ character varying,
  direccion_ character varying,
  telefono_ character varying,
  ope character
)
returns integer as
$body$
begin
	if (ope = 'INS') then
		idconductor_ = (select coalesce(max(idconductor),0) from conductor) + 1;
		insert into conductor values(idconductor_,tdoc_,ndoc_,nlicencia_,nombre_,direccion_,telefono_);
	else
		update conductor 
		set tdoc = tdoc_,
		ndoc = ndoc_,
		nlicencia = nlicencia_,
		nombre = nombre_,
		direccion = direccion_,
		telefono = telefono_
		where idconductor=idconductor_;
	end if;
	return (idconductor_);
end;
$body$
language plpgsql volatile
cost 100;

-- creando la vista
create or replace view vw_reg_conductor as
select		cond.idconductor,
		cond.tdoc,
		cond.ndoc,
		cond.nlicencia,
		cond.nombre,
		cond.direccion,
		cond.telefono
from		conductor cond;


-- creando la tabla
create table marca(
  idmarca	integer not null,
  nombre	character varying(50) not null,
  constraint pk_marca_idmarca primary key(idmarca),
  constraint uq_marca_nombre unique(nombre)
);

-- creando una funcion
create or replace function fn_marca(
  idmarca_ integer,
  nombre_ character varying,
  ope character
) 
returns integer as
$body$
begin
	if (ope = 'INS') then
		idmarca_ = (select coalesce(max(idmarca),0) from marca) + 1;
		insert into marca values(idmarca,nombre_);
	else
		update marca 
		set nombre = nombre_
		where idmarca=idmarca_;
	end if;
	return (idmarca_);
end;
$body$
language plpgsql volatile
cost 100;

-- creando vista
create or replace view vw_reg_marca as
select		idmarca,
		nombre
from		marca;


-- creando la tabla modelo
create table modelo(
  idmodelo	integer not null,
  nombre	character varying(50) not null,
  constraint pk_modelo_idmodelo primary key(idmodelo),
  constraint uq_modelo_nombre unique(nombre)
);

-- creando function
create or replace function fn_modelo(
  idmodelo_ integer,
  nombre_ character varying,
  ope character
) 
returns integer as
$body$
begin
	if (ope = 'INS') then
		idmodelo_ = (select coalesce(max(idmodelo),0) from modelo) + 1;
		insert into modelo values(idmodelo,nombre_);
	else
		update modelo 
		set nombre = nombre_
		where idmodelo=idmodelo_;
	end if;
	return (idmodelo_);
end;
$body$
language plpgsql volatile
cost 100;

-- creando vista vw_modelo
create or replace view vw_reg_modelo as
select		idmodelo,
		nombre
from		modelo;


-- creando la tabla automovil
create table automovil(
  idautomovil	integer not null,
  idmarca	integer not null,
  idmodelo	integer not null,
  placa		character varying(8),
  codigo	character varying(8),
  color		character varying(24),
  constraint pk_automovil_idautomovil primary key(idautomovil),
  constraint fk_automovil_idmarca foreign key(idmarca)
	references marca(idmarca) match simple
	on update no action on delete no action,
  constraint fk_automovil_idmodelo foreign key(idmodelo)
	references modelo(idmodelo) match simple
	on update no action on delete no action,
  constraint uq_automovil_placa unique(placa)
);

-- creando la funcion
create or replace function fn_automovil(
  idautomovil_ integer,
  idmodelo_ integer,
  idmarca_ integer,
  placa_ character varying, 
  codigo_ character varying,
  color_ character varying,
  ope character varying
)
returns integer as
$body$
begin
	if (ope = 'INS') then
		idautomovil_ = (select coalesce(max(idautomovil),0) from automovil) + 1;
		insert into automovil values(idautomovil_,idmodelo_,idmarca_,placa_,codigo_,color_);
	else
		update automovil 
		set idmodelo = idmodelo_,
		idmarca = idmarca_,
		placa = nlicencia_,
		codigo = nombre_,
		color = color_
		where idautomovil=idautomovil_;
	end if;
	return (idautomovil_);
end;
$body$
language plpgsql volatile
cost 100;

-- creando vista
create or replace view vw_reg_automovil as
select		auto.idautomovil,
		auto.idmarca,
		auto.idmodelo,
		auto.placa,
		auto.codigo,
		auto.color
from		automovil auto 
join		modelo modl on modl.idmodelo=auto.idmodelo
join		marca marc on marc.idmarca=auto.idmarca;

-- creando vista
create or replace view vw_qry_automovil as
select		auto.idautomovil,
		marc.nombre as marca,
		modl.nombre as modelo,
		auto.placa,
		auto.codigo,
		auto.color,
		auto.idmarca,
		auto.idmodelo
from		automovil auto 
join		modelo modl on modl.idmodelo=auto.idmodelo
join		marca marc on marc.idmarca=auto.idmarca;


-- creando la tabla
create table cliente(
  idcliente	integer not null,
  tdoc		character(3) not null,
  ndoc		character varying(12) not null,
  nombre	character varying(80) not null,
  correo	character varying(80) not null,
  telefono	character varying(25) not null,
  constraint pk_cliente_idcliente primary key(idcliente),
  constraint uq_cliente_tdoc_ndoc unique(tdoc,ndoc),
  constraint uq_cliente_correo unique(correo)
);

-- creando funcion
create or replace function fn_cliente(
  idcliente_ integer,
  tdoc_ character varying,
  ndoc_ character varying, 
  nombre_ character varying,
  correo_ character varying,
  telefono_ character varying,
  ope character
)
returns integer as
$body$
begin
	if (ope = 'INS') then
		idcliente_ = (select coalesce(max(idcliente),0) from cliente) + 1;
		insert into cliente values(idcliente_,tdoc_,ndoc_,nombre_,correo_,telefono_);
	else
		update cliente  
		set tdoc = tdoc_,
		ndoc = ndoc_,
		nlicencia = nlicencia_,
		nombre = nombre_,
		correo = correo_,
		telefono = telefono_
		where idcliente=idcliente_;
	end if;
	return (idcliente_);
end;
$body$
language plpgsql volatile
cost 100;

-- creando la vista
create or replace view vw_reg_cliente as
select		idcliente,
		tdoc,
		ndoc,
		nombre,
		correo,
		telefono
from		cliente;


-- creando la tabla
create table configuracion(
  campo		character varying (50) not null,
  valor 	text not null,
  constraint pk_conf_campo primary key(campo)
);

insert into configuracion values('KILOMETROS_MINIMO_RECORRIDO','2.00');
insert into configuracion values('COSTO_MINIMO_RECORRIDO','5.00');
insert into configuracion values('COSTO_MINUTO_EXTRA_RECORRIDO','1.50');

-- creando la vista
create or replace view vw_configuracion as
select		campo,
		valor
from		configuracion;


-- creando la tabla
create table servicio(
  idservicio	integer not null,
  idconductor	integer not null,
  idautomovil	integer not null,
  idcliente	integer not null,
  fecha		timestamp without time zone not null,	-- fecha que solicita el servicio
  fecha_ini	timestamp without time zone,		-- fecha que inicia el recorrido
  fecha_fin	timestamp without time zone,		-- fecha que finaliza el recorrido
  origen	character varying(80) not null,
  destino	character varying(80) not null,			
  distancia	numeric(6,1) not null,	-- distancia recorrida
  ctmr		numeric(6,2) not null,	-- costo tiempo minimo recorrido
  cmer		numeric(6,2) not null,	-- costo minuto extra recorrido
  costo		numeric(6,2) not null,	-- costo de servicio
  constraint pk_servicio_idservicio primary key(idservicio),
  constraint pk_servicio_idconductor foreign key(idconductor)
	references conductor(idconductor) match simple
	on update no action on delete no action,
  constraint pk_servicio_idautomovil foreign key(idautomovil)
	references automovil(idautomovil) match simple
	on update no action on delete no action,
  constraint pk_servicio_idcliente foreign key(idcliente)
	references cliente(idcliente) match simple
	on update no action on delete no action
);

-- creando funcion
create or replace function fn_servicio_solicitar(
  idservicio_ integer,
  idconductor_ character varying,
  idautomovil_ character varying,
  idcliente_ character varying,
  fecha_ timestamp without time zone,
  origen_ character varying
)
returns integer as
$body$
begin
	idservicio_ = (select coalesce(max(idservicio),0) from servicio) + 1;
	insert into servicio values(idservicio_,idconductor_,idautomovil_,idcliente_,fecha_,null,
		null,origen_,' ',0.00,0.00,0.00,0.00);
	return (idservicio_);
end;
$body$
language plpgsql volatile
cost 100;

create or replace function fn_servicio_registrar(
  idservicio_ integer,
  fecha_ini_ timestamp without time zone,
  fecha_fin_ timestamp without time zone,
  destino_ character varying,
  distancia_ numeric,
  ctmr_ numeric,
  cmer_ numeric,
  costo_ numeric,
  ope character
)
returns integer as
$body$
begin
	update 	servicio  
		set fecha_ini = fecha_ini_,
		fecha_fin = fecha_fin_,
		destino = destino_,
		distancia = distancia_,
		ctmr = ctmr_,
		cmer=cmer_,
		costo=costo_
	where 	idservicio=idservicio_;
	return (idservicio_);
end;
$body$
language plpgsql volatile
cost 100;

-- creando la vista
create or replace view vw_reg_servicio as
select		idservicio,
		idconductor,
		idautomovil,
		idcliente,
		fecha,
		fecha_ini,
		fecha_fin,
		origen,
		destino,
		distancia,
		ctmr,
		cmer,
		costo
from		servicio;

-- creando la vista
create or replace view vw_qry_servicio as
select		ser.idservicio,
		con.nombre as conductor,
		mar.nombre as marca,
		mod.nombre as modelo,
		aut.placa,
		cli.ndoc,
		cli.nombre,
		ser.fecha,
		ser.fecha_ini,
		ser.fecha_fin,
		ser.origen,
		ser.destino,
		ser.distancia,
		ser.ctmr,
		ser.cmer,
		ser.costo
from		servicio ser
join		cliente cli on cli.idcliente=ser.idcliente
join		conductor con on con.idconductor=ser.idconductor
join		automovil aut on aut.idautomovil=ser.idautomovil
join		marca mar on mar.idmarca=aut.idmarca
join		modelo mod on mod.idmodelo=aut.idmodelo;


