drop table if exists teammembers;
drop table if exists teamcommitments;
drop table if exists projecttracks;
drop table if exists projects;
drop table if exists worktypes;
drop table if exists teams;
drop table if exists employees;
drop table if exists countries;

create table employees (
    id						int				not null auto_increment,
	pernr					char(7)         not null default '',
    name					varchar(100)	not null default '',
    primary key(id)
) engine=InnoDB;
create unique index employees_index on employees(pernr); 
 
create table teams (
    id						int				not null auto_increment,
   	name					char(5)			not null default '',
    description				varchar(30)		not null default '',
    primary key(id)
) engine=InnoDB;
create unique index teams_index on teams(name); 

create table worktypes (
    id						int				not null auto_increment,
	name					char(5)			not null default '',
	description				varchar(30)		default '',
	preload					boolean			default '0',
	primary key(id)
) engine=InnoDB;
create unique index worktypes_index on worktypes(name);

create table countries (
    id						int				not null auto_increment,
	isocode					char(2)			not null default '',
	name					varchar(30)		default '',
	primary key(id)
) engine=InnoDB;
create unique index countries_iso_index on countries(isocode);
create unique index countries_name_index on countries(name);
	
create table teammembers (
    id						int				not null auto_increment,
    eid						int				not null,
    tid						int				not null,
	endda					date			not null default '99991231',
	begda					date			not null default '19000101',
	foreign key (id) references employees(id),
	foreign key (id) references teams(id),	
    primary key(id)
) engine=InnoDB;
create unique index teammembers_index on teammembers(eid,tid,endda);

create table projects (
    id						int				not null auto_increment,
    name					varchar(100)	not null default '',
	planend					date			not null default '99991231',
	planbeg					date			not null default '19000101',
	worktype_id				int				not null,
	planeffort				int(5)			not null,
	responsible_id	 		int				not null,
	country_id				int				not null,		
	foreign key (worktype_id) references worktypes(id),
	foreign key (country_id) references countries(id),
	foreign key (responsible_id) references employees(id),
    primary key(id)
) engine=InnoDB;
create unique index projects_index on projects(name);

create table teamcommitments (
    id						int				not null auto_increment,
    tid						int				not null,
    yearmonth				numeric(6)		not null default '000000',
	pid						int				not null,
	dayscommitted			int(3)			not null,	
	foreign key (tid) references teams(id),
	foreign key (pid) references projects(id),
    primary key(id)
) engine=InnoDB;
create unique index teamcommitments_index on teamcommitments(tid,yearmonth,pid);

create table projecttracks (
    id						int				not null auto_increment,
    tid						int				not null,
    yearmonth				numeric(6)		not null default '000000',
	pid						int				not null,
	reportdate				date			not null,
	daysbooked				int(3)			not null,	
	foreign key (tid) references teams(id),
	foreign key (pid) references projects(id),
    primary key(id)
) engine=InnoDB;
create unique index projecttracks_index on projecttracks(tid,yearmonth,pid,reportdate);