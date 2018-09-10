/* locations */

UPDATE locations SET min_village_low = (SELECT min(stars) FROM quests WHERE locations._id == quests.location_id AND hub == 'Village' AND stars <= 6 and stars > 0);
UPDATE locations SET min_village_high = (SELECT min(stars) FROM quests WHERE locations._id == quests.location_id AND hub == 'Village' AND stars >= 7 and stars > 0);

UPDATE locations SET min_guild_low = (SELECT min(stars) FROM quests WHERE locations._id == quests.location_id AND hub == 'Guild' AND stars <= 3);
UPDATE locations SET min_guild_high = (SELECT min(stars) FROM quests WHERE locations._id == quests.location_id AND hub == 'Guild' AND stars >= 4 AND stars <= 7);
UPDATE locations SET min_guild_g = (SELECT min(stars) FROM quests WHERE locations._id == quests.location_id AND hub == 'Guild' AND stars >= 8);

/* monsters */

UPDATE monsters SET min_village_low = (SELECT min(quests.stars) FROM monster_to_quest LEFT JOIN quests ON quests._id = monster_to_quest.quest_id WHERE monster_to_quest.monster_id == monsters._id AND quests.hub == 'Village' AND stars <= 6);
UPDATE monsters SET min_village_high = (SELECT min(quests.stars) FROM monster_to_quest LEFT JOIN quests ON quests._id = monster_to_quest.quest_id WHERE monster_to_quest.monster_id == monsters._id AND quests.hub == 'Village' AND stars >= 7);

UPDATE monsters SET min_guild_low = (SELECT min(quests.stars) FROM monster_to_quest LEFT JOIN quests ON quests._id = monster_to_quest.quest_id WHERE monster_to_quest.monster_id == monsters._id AND quests.hub == 'Guild' AND stars <= 3);
UPDATE monsters SET min_guild_high = (SELECT min(quests.stars) FROM monster_to_quest LEFT JOIN quests ON quests._id = monster_to_quest.quest_id WHERE monster_to_quest.monster_id == monsters._id AND quests.hub == 'Guild' AND stars >= 4 AND stars <= 7);
UPDATE monsters SET min_guild_g = (SELECT min(quests.stars) FROM monster_to_quest LEFT JOIN quests ON quests._id = monster_to_quest.quest_id WHERE monster_to_quest.monster_id == monsters._id AND quests.hub == 'Guild' AND stars >= 8);

UPDATE monsters SET min_village_low = 0 WHERE min_village_low IS NULL AND class = 1;
UPDATE monsters SET min_village_high = 0 WHERE min_village_high IS NULL AND class = 1;
UPDATE monsters SET min_guild_low = 0 WHERE min_guild_low IS NULL AND class = 1;
UPDATE monsters SET min_guild_high = 0 WHERE min_guild_high IS NULL AND class = 1;
UPDATE monsters SET min_guild_g = 0 WHERE min_guild_g IS NULL AND class = 1;

/* gathering */

UPDATE gathering set min_village_rank = (SELECT min(min_village_high) FROM locations WHERE gathering.location_id = locations._id) WHERE gathering.rank == 'HR';
UPDATE gathering set min_village_rank = (SELECT min(min_village_low) FROM locations WHERE gathering.location_id = locations._id) WHERE gathering.rank == 'LR';
UPDATE gathering set min_guild_rank = (SELECT min(min_guild_g) FROM locations WHERE gathering.location_id = locations._id) WHERE gathering.rank == 'G';
UPDATE gathering set min_guild_rank = (SELECT min(min_guild_high) FROM locations WHERE gathering.location_id = locations._id) WHERE gathering.rank == 'HR';
UPDATE gathering set min_guild_rank = (SELECT min(min_guild_low) FROM locations WHERE gathering.location_id = locations._id) WHERE gathering.rank == 'LR';

/* hunting_rewards */

UPDATE hunting_rewards set min_village_rank = (SELECT min(min_village_high) FROM monsters WHERE hunting_rewards.monster_id = monsters._id) WHERE hunting_rewards.rank == 'HR';
UPDATE hunting_rewards set min_village_rank = (SELECT min(min_village_low) FROM monsters WHERE hunting_rewards.monster_id = monsters._id) WHERE hunting_rewards.rank == 'LR';

UPDATE hunting_rewards set min_guild_rank = (SELECT min(min_guild_g) FROM monsters WHERE hunting_rewards.monster_id = monsters._id) WHERE hunting_rewards.rank == 'G';
UPDATE hunting_rewards set min_guild_rank = (SELECT min(min_guild_high) FROM monsters WHERE hunting_rewards.monster_id = monsters._id) WHERE hunting_rewards.rank == 'HR';
UPDATE hunting_rewards set min_guild_rank = (SELECT min(min_guild_low) FROM monsters WHERE hunting_rewards.monster_id = monsters._id) WHERE hunting_rewards.rank == 'LR';

/* quest_rewards */

UPDATE quest_rewards set min_village_rank = (SELECT quests.stars FROM quests WHERE quests._id = quest_rewards.quest_id AND quests.hub == 'Village');
UPDATE quest_rewards set min_guild_rank = (SELECT quests.stars FROM quests WHERE quests._id = quest_rewards.quest_id AND quests.hub == 'Guild');

/* Min source ranks poulated, now min component item ranks */

UPDATE items SET min_village_rank = null, min_guild_rank = null;

UPDATE items SET min_village_rank = 0, min_guild_rank = 0 WHERE name LIKE '%Materials';


UPDATE items SET min_village_rank = (SELECT MIN(gathering.min_village_rank) FROM gathering WHERE gathering.item_id = items._id) WHERE items.min_village_rank IS NULL OR EXISTS (SELECT gathering.min_village_rank FROM gathering WHERE gathering.item_id = items._id AND gathering.min_village_rank < items.min_village_rank);

UPDATE items SET min_guild_rank = (SELECT MIN(gathering.min_guild_rank) FROM gathering WHERE gathering.item_id = items._id) WHERE items.min_guild_rank IS NULL OR EXISTS (SELECT gathering.min_guild_rank FROM gathering WHERE gathering.item_id = items._id AND gathering.min_guild_rank < items.min_guild_rank);

UPDATE items SET min_village_rank = (SELECT MIN(hunting_rewards.min_village_rank) FROM hunting_rewards WHERE hunting_rewards.item_id = items._id) WHERE items.min_village_rank IS NULL OR EXISTS (SELECT hunting_rewards.min_village_rank FROM hunting_rewards WHERE hunting_rewards.item_id = items._id AND hunting_rewards.min_village_rank < items.min_village_rank);

UPDATE items SET min_guild_rank = (SELECT MIN(hunting_rewards.min_guild_rank) FROM hunting_rewards WHERE hunting_rewards.item_id = items._id) WHERE items.min_guild_rank IS NULL OR EXISTS (SELECT hunting_rewards.min_guild_rank FROM hunting_rewards WHERE hunting_rewards.item_id = items._id AND hunting_rewards.min_guild_rank < items.min_guild_rank);

UPDATE items SET min_village_rank = (SELECT MIN(quest_rewards.min_village_rank) FROM quest_rewards WHERE quest_rewards.item_id = items._id) WHERE items.min_village_rank IS NULL OR EXISTS (SELECT quest_rewards.min_village_rank FROM quest_rewards WHERE quest_rewards.item_id = items._id AND quest_rewards.min_village_rank < items.min_village_rank);

UPDATE items SET min_guild_rank = (SELECT MIN(quest_rewards.min_guild_rank) FROM quest_rewards WHERE quest_rewards.item_id = items._id) WHERE items.min_guild_rank IS NULL OR EXISTS (SELECT quest_rewards.min_guild_rank FROM quest_rewards WHERE quest_rewards.item_id = items._id AND quest_rewards.min_guild_rank < items.min_guild_rank);

/* Combining */

UPDATE combining SET min_village_rank1 = (SELECT MIN(items.min_village_rank) FROM items WHERE combining.item_1_id = items._id);
UPDATE combining SET min_village_rank2 = (SELECT MIN(items.min_village_rank) FROM items WHERE combining.item_2_id = items._id);

UPDATE combining SET min_guild_rank1 = (SELECT MIN(items.min_guild_rank) FROM items WHERE combining.item_1_id = items._id);
UPDATE combining SET min_guild_rank2 = (SELECT MIN(items.min_guild_rank) FROM items WHERE combining.item_2_id = items._id);

UPDATE combining SET min_village_rank = MAX(min_village_rank1, min_village_rank2);
UPDATE combining SET min_guild_rank = MAX(min_guild_rank1, min_guild_rank2);

/* Combining Result Item */

UPDATE items SET min_village_rank = (SELECT MIN(combining.min_village_rank) FROM combining WHERE combining.item_1_id = items._id OR combining.item_2_id = items._id) WHERE items.min_village_rank IS NULL OR EXISTS (SELECT combining.min_village_rank FROM combining WHERE (combining.item_1_id = items._id OR combining.item_2_id = items._id) AND combining.min_village_rank < items.min_village_rank);

UPDATE items SET min_guild_rank = (SELECT MIN(combining.min_guild_rank) FROM combining WHERE combining.item_1_id = items._id OR combining.item_2_id = items._id) WHERE items.min_guild_rank IS NULL OR EXISTS (SELECT combining.min_guild_rank FROM combining WHERE (combining.item_1_id = items._id OR combining.item_2_id = items._id) AND combining.min_guild_rank < items.min_guild_rank);

/* Component items min rank set, now update components table */

UPDATE components set min_village_rank = (SELECT MIN(min_village_rank) FROM items WHERE components.component_item_id = items._id);
UPDATE components set min_guild_rank = (SELECT MIN(min_guild_rank) FROM items WHERE components.component_item_id = items._id);

/* This is bad but we are missing things like veggie elder 
UPDATE components set min_village_rank = 0, min_guild_rank = 0 WHERE min_village_rank IS NULL AND min_guild_rank IS NULL; */

UPDATE components set min_village_rank = 0, min_guild_rank = 0 WHERE EXISTS (SELECT weapons._id FROM weapons WHERE weapons._id = components.component_item_id);

/* Final destination, Armor, Weapons, Decorations */

UPDATE items SET min_village_rank = (SELECT MAX(components.min_village_rank) FROM components WHERE components.created_item_id = items._id AND components.min_village_rank IS NOT NULL) WHERE items.min_village_rank IS NULL OR EXISTS (SELECT components.min_village_rank FROM components WHERE components.created_item_id = items._id AND components.min_village_rank > items.min_village_rank AND components.min_village_rank IS NOT NULL);

UPDATE items SET min_guild_rank = (SELECT MAX(components.min_guild_rank) FROM components WHERE components.created_item_id = items._id AND components.min_guild_rank IS NOT NULL) WHERE items.min_guild_rank IS NULL OR EXISTS (SELECT components.min_guild_rank FROM components WHERE components.created_item_id = items._id AND components.min_guild_rank > items.min_guild_rank AND components.min_guild_rank IS NOT NULL);

/* Clear Armor/Weapon/Decoration minimum rank where a component isn't obtainable */

/*UPDATE items SET min_village_rank = NULL WHERE items.sub_type != '' AND EXISTS (SELECT components.created_item_id FROM components WHERE components.created_item_id = items._id AND components.min_village_rank IS NULL);
UPDATE items SET min_guild_rank = NULL WHERE items.sub_type != '' AND EXISTS (SELECT components.created_item_id FROM components WHERE components.created_item_id = items._id AND components.min_guild_rank IS NULL);
*/

