INSERT INTO systemsPopulated (
id,
edsm_id,
name,
x,
y,
z,
population,
is_populated,
government_id,
government,
allegiance_id,
allegiance,
state_id,
state,
security_id,
security,
primary_economy_id,
primary_economy,
power,
power_state,
power_state_id,
needs_permit,
updated_at,
simbad_ref,
controlling_minor_faction_id,
controlling_minor_faction,
reserve_type_id,
reserve_type
)




SELECT tempSystems.*
 FROM OPENROWSET (BULK '/home/shared/sql/systems_populated.json', SINGLE_CLOB) johnny
 CROSS APPLY OPENJSON(BulkColumn)
WITH
(
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
) AS tempSystems

CREATE TABLE systemsPopulated
(
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



SELECT * FROM factions
SELECT * FROM systemsPopulated

SELECT
	systemsPopulated.name AS 'Star System',
	factions.name,
	factions.government,
	factions.allegiance,
	factions.state,
	factions.home_system_id,
	factions.is_player_faction
FROM factions
INNER JOIN systemsPopulated ON factions.home_system_id=systemsPopulated.id


WHERE home_system_id IN (
	SELECT id FROM systemsPopulated
	WHERE power = 'Li Yong-Rui'
	)
AND is_player_faction = 'true'
ORDER BY government


SELECT
	systemsPopulated.name,
	systemsPopulated.government,
	systemsPopulated.controlling_minor_faction,
	factions.is_player_faction,
	systemsPopulated.power_state
FROM systemsPopulated
INNER JOIN factions ON systemsPopulated.controlling_minor_faction_id=factions.id
WHERE 
	power = 'Li Yong-Rui'
	and systemsPopulated.power_state = 'Control'
	and systemsPopulated.government = 'Corporate'
ORDER BY power_state, is_player_faction DESC
	

	AND controlling_minor_faction IN (
		SELECT 


SELECT name, x, y, z FROM systemsPopulated
WHERE name in ('Lembava','Pikum','Kalak','Sol')


