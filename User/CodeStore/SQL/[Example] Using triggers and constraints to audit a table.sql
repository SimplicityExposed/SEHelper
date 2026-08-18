SOURCE: http://stackoverflow.com/questions/21493178/need-a-datetime-field-in-ms-sql-that-automatically-updates-when-the-record-is-mo
SOURCE USER: http://stackoverflow.com/users/2577687/crafty-dba

Okay, I always like to keep track of not only when something happened but who did it!

Lets create a test table in [tempdb] named [dwarfs]. At a prior job, a financial institution, we keep track of inserted (create) date and updated (modify) date.

-- just playing
use tempdb;
go

-- drop table
if object_id('dwarfs') > 0
drop table dwarfs
go

-- create table
create table dwarfs
(
asigned_id int identity(1,1),
full_name varchar(16),
ins_date datetime,
ins_name sysname,
upd_date datetime,
upd_name sysname,
);
go

-- insert/update dates
alter table dwarfs
    add constraint [df_ins_date] default (getdate()) for ins_date;
alter table dwarfs
    add constraint [df_upd_date] default (getdate()) for upd_date;

-- insert/update names
alter table dwarfs
    add constraint [df_ins_name] default (coalesce(suser_sname(),'?')) for ins_name;

alter table dwarfs
    add constraint [df_upd_name] default (coalesce(suser_sname(),'?')) for upd_name;
go

For updates, but the inserted and deleted tables exist. I choose to join on the inserted for the update.

-- create the update trigger
create trigger trg_changed_info on dbo.dwarfs
for update
as
begin

    -- nothing to do?
    if (@@rowcount = 0)
      return;

    update d
    set 
       upd_date = getdate(),
       upd_name = (coalesce(suser_sname(),'?'))
    from
       dwarfs d join inserted i 
    on 
       d.asigned_id = i.asigned_id;

end
go

Last but not least, lets test the code. Anyone can type a untested TSQL statement in. However, I always stress testing to my team!

-- remove data
truncate table dwarfs;
go

-- add data
insert into dwarfs (full_name) values
('bilbo baggins'),
('gandalf the grey');
go

-- show the data
select * from dwarfs;

-- update data
update dwarfs 
set full_name = 'gandalf'
where asigned_id = 2;

-- show the data
select * from dwarfs;

The output. I only waited 10 seconds between the insert and the delete. Nice thing is that who and when are both captured.