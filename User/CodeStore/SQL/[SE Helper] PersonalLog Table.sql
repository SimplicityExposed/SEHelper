CREATE TABLE PersonalLog (
	EntryNumber INT IDENTITY(1,1),
	LogLabel	NVARCHAR(255),
	LogEntry	NVARCHAR(MAX),
	LoggedOn	DATETIME,
	LoggedBy	SYSNAME,
	UpdatedOn	DATETIME,
	UpdatedBy	SYSNAME,);

-- insert/update dates
alter table PersonalLog
    add constraint [df_ins_date] default (getdate()) for LoggedOn;
alter table PersonalLog
    add constraint [df_upd_date] default (getdate()) for UpdatedOn;

-- insert/update names
alter table PersonalLog
    add constraint [df_ins_name] default (coalesce(suser_sname(),'?')) for LoggedBy;

alter table PersonalLog
    add constraint [df_upd_name] default (coalesce(suser_sname(),'?')) for UpdatedBy;