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