/* These queries are to double check results from MinRank.sql */

/* Sources */
SELECT name, min_village_low, min_village_high, min_guild_low, min_guild_high FROM locations
SELECT name, min_village_low, min_village_high, min_guild_low, min_guild_high FROM monsters

/* Relationship Links */
SELECT name, gathering.min_village_rank, gathering.min_guild_rank FROM gathering LEFT JOIN items on gathering.item_id = items._id
SELECT min_village_rank, min_guild_rank FROM combining
SELECT * FROM components
SELECT * FROM quest_rewards

SELECT 
created._id as created_id, 
created.name as created_name, 
component._id as component_id, 
component.name as component_name, 
components.min_village_rank, 
components.min_guild_rank 
FROM components 
left join items as created on created._id = created_item_id 
left join items as component on component._id = component_item_id;

/* Results */

SELECT weapons._id, name, min_village_rank, min_guild_rank FROM weapons LEFT JOIN items ON weapons._id = items._id 
SELECT weapons._id, name, min_village_rank, min_guild_rank FROM weapons LEFT JOIN items ON weapons._id = items._id WHERE min_village_rank IS NULL AND min_guild_rank IS NULL


/* Debugging single item */

/* Look at created item */

SELECT _id, name, min_village_rank, min_guild_rank from items where _id = 590086
SELECT * FROM components WHERE components.created_item_id = 590086
SELECT MAX(components.min_village_rank) FROM components WHERE components.created_item_id = 590086 AND components.min_village_rank IS NOT NULL

/* Look at component item */

SELECT _id, name, min_village_rank, min_guild_rank from items where _id = 310

/* Look at component item sources */

SELECT item_id, location_id, MIN(min_village_rank) FROM gathering where item_id = 310
SELECT quest_id, item_id, MIN(min_village_rank) FROM quest_rewards WHERE item_id = 310
SELECT item_id, monster_id, MIN(min_village_rank) FROM hunting_rewards WHERE item_id = 310
SELECT created_item_id, item_1_id, item_2_id, MIN(min_village_rank) FROM combining WHERE created_item_id = 310
