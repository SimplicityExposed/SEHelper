/home/shared/sql/


BULK INSERT systems
FROM '/home/shared/sql/systems.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ','
	--ROWTERMINATOR = '\n'
)
GO

SELECT * FROM systems

CREATE TABLE systems (
	id								VARCHAR(250),
	edsm_id							VARCHAR(250),
	name							VARCHAR(250),
	x								VARCHAR(250),
	y								VARCHAR(250),
	z								VARCHAR(250),
	population						VARCHAR(250),
	is_populated					VARCHAR(250),
	government_id					VARCHAR(250),
	government						VARCHAR(250),
	allegiance_id					VARCHAR(250),
	allegiance						VARCHAR(250),
	state_id						VARCHAR(250),
	state							VARCHAR(250),
	security_id						VARCHAR(250),
	security						VARCHAR(250),
	primary_economy_id				VARCHAR(250),
	primary_economy					VARCHAR(250),
	power							VARCHAR(250),
	power_state						VARCHAR(250),
	power_state_id					VARCHAR(250),
	needs_permit					VARCHAR(250),
	updated_at						VARCHAR(250),
	simbad_ref						VARCHAR(250),
	controlling_minor_faction_id	VARCHAR(250),
	controlling_minor_faction		VARCHAR(250),
	reserve_type_id					VARCHAR(250),
	reserve_type					VARCHAR(MAX)
)


DROP TABLE systems