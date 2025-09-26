create table hr.countriess (
   country_id   char(2) primary key,
   country_name varchar2(40) not null,
   region_id    number, --fk,
   constraint fk_countriess_regions foreign key ( region_id ) --fk_countriess_regios nama constraint, kalo mau drop nama ini
      references hr.regions ( region_id )
         on delete cascade --berarti bahwa jika catatan induk dihapus, catatan anak apa pun juga dihapus
)

insert into hr.countriess (
   country_id,
   country_name,
   region_id
) values ( 01,
           'Indonesia',
           3 );
insert into hr.countriess (
   country_id,
   country_name,
   region_id
) values ( 02,
           'Malaysia',
           3 );
insert into hr.countriess (
   country_id,
   country_name,
   region_id
) values ( 03,
           'Thailand',
           3 );
insert into hr.countriess (
   country_id,
   country_name,
   region_id
) values ( 04,
           'USA',
           2 );
insert into hr.countriess (
   country_id,
   country_name,
   region_id
) values ( 05,
           'Mexico',
           2 );
insert into hr.countriess (
   country_id,
   country_name,
   region_id
) values ( 06,
           'Australia',
           3 );
insert into hr.countriess (
   country_id,
   country_name,
   region_id
) values ( 07,
           'Germany',
           1 );

select hr.countriess.country_name,
       hr.regions.region_name
  from hr.countriess,
       hr.regions
 where hr.countriess.region_id = hr.regions.region_id;

select hr.countriess.country_name,
       hr.regions.region_name
  from hr.countriess
 inner join hr.regions
on hr.countriess.region_id = hr.regions.region_id;

select c.country_name,
       r.region_name
  from hr.countriess c
  join hr.regions r
on r.region_id = c.region_id;

select c.country_name,
       r.region_name
  from hr.countriess c
  left join hr.regions r
on r.region_id = c.region_id; --left cek column kiri/countriess dulu

select c.country_name,
       r.region_name
  from hr.countriess c
 right join hr.regions r
on r.region_id = c.region_id; --right cek column kiri/countriess dulu

select c.country_name,
       r.region_name
  from hr.countriess c
 inner join hr.regions r
on r.region_id = c.region_id;

select c.country_name,
       r.region_name
  from hr.countriess c
  full outer join hr.regions r
on r.region_id = c.region_id; --sama dengan right tapi lebih lambat

--subquery, query dalam query
select c.country_id, --jika ada persamaan buat alias
       c.country_name,
       (
          select region_name
            from hr.regions
           where region_id = c.region_id
       ) as region_name
  from hr.countriess c;

--select banner from v$version where rownum = 1;
create table hr.country_stats (
   stat_id    number primary key,
   area       number(8,0),
   population number(8,0)
);

create sequence hr.stat_id start with 1;

create or replace trigger hr.trg_stat_id before
   insert on hr.country_stats
   for each row
begin
   select hr.stat_id.nextval
     into :new.stat_id
     from dual;
end;

select *
  from hr.country_stats;

alter table hr.country_stats add city_name varchar(30);

insert into hr.country_stats (
   city_name,
   area,
   population
) values ( 'Yogyakarta',
           42,
           410262 );
insert into hr.country_stats (
   city_name,
   area,
   population
) values ( 'Bantul',
           508.85,
           995264 );
insert into hr.country_stats (
   city_name,
   area,
   population
) values ( 'Sleman',
           574.82,
           1180479 );
insert into hr.country_stats (
   city_name,
   area,
   population
) values ( 'Gunung Kidul',
           1431.42,
           755977 );
insert into hr.country_stats (
   city_name,
   area,
   population
) values ( 'Kulon Progo',
           586.28,
           445655 );

truncate table hr.country_stats;

select *
  from hr.country_stats;

select ( population / area ) as kepadatan
  from hr.country_stats
 where city_name = 'Yogyakarta';
select city_name,
       ( population / area ) as kepadatan
  from hr.country_stats;
select sum(population) as total_populasi
  from hr.country_stats
 group by city_name;
select sum(population) as total_populasi
  from hr.country_stats; --total
select avg(population) as total_populasi
  from hr.country_stats; --rata-rata
select max(population) as total_populasi
  from hr.country_stats; --max
select min(population) as total_populasi
  from hr.country_stats; --min
select count(*)
  from hr.country_stats
 where area < 600
   and area > 100; --total berapa

-------------------------------------------------------------------------------------

create table hr.dep (
   deptno   number,
   name     varchar2(50) not null,
   location varchar2(50),
   constraint pk_departments primary key ( deptno )
);

create table hr.emp (
   empno      number,
   name       varchar2(50) not null,
   job        varchar2(50),
   manager    number,
   hiredate   date,
   salary     number(7,2),
   commission number(7,2),
   deptno     number,
   constraint pk_employees primary key ( empno ),
   constraint fk_employess_deptno foreign key ( deptno )
      references hr.dep ( deptno )
);

create or replace trigger hr.dep_biu before
   insert or update or delete on hr.dep
   for each row
begin
   if
      inserting
      and :new.deptno is null
   then
      :new.deptno := to_number ( sys_guid(),'xxxxxxxxxxxx' );
   end if;
end;
/

create or replace trigger hr.emp_biu before
   insert or update or delete on hr.emp
   for each row
begin
   if
      inserting
      and :new.empno is null
   then
      :new.empno := to_number ( sys_guid(),'xxxxxxxxxxxx' );
   end if;
end;
/