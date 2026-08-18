INSERT INTO factions(id,name,updated_at,government_id,government,allegiance_id,allegiance,state_id,state,home_system_id,is_player_faction)



SELECT * --tempFactions.*
 FROM OPENROWSET (BULK '/home/shared/sql/bodies.jsonl', SINGLE_CLOB) johnny
 CROSS APPLY OPENJSON(BulkColumn)




WITH
(
	id				BIGINT,
	name			VARCHAR(250),
	updated_at		BIGINT,
	government_id	INT,
	government		VARCHAR(250),
	allegiance_id	INT,
	allegiance		VARCHAR(250),
	state_id		INT,
	state			VARCHAR(250),
	home_system_id	INT,
	is_player_faction	VARCHAR(10)
) AS tempFactions