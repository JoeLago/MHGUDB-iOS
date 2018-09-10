/* Min Rank Schema Updates */

ALTER TABLE locations ADD COLUMN min_village_low INTEGER;
ALTER TABLE locations ADD COLUMN min_village_high INTEGER;
ALTER TABLE locations ADD COLUMN min_guild_low INTEGER;
ALTER TABLE locations ADD COLUMN min_guild_high INTEGER;
ALTER TABLE locations ADD COLUMN min_guild_g INTEGER;

ALTER TABLE monsters ADD COLUMN min_village_low INTEGER;
ALTER TABLE monsters ADD COLUMN min_village_high INTEGER;
ALTER TABLE monsters ADD COLUMN min_guild_low INTEGER;
ALTER TABLE monsters ADD COLUMN min_guild_high INTEGER;
ALTER TABLE monsters ADD COLUMN min_guild_g INTEGER;

ALTER TABLE gathering ADD COLUMN min_village_rank INTEGER;
ALTER TABLE gathering ADD COLUMN min_guild_rank INTEGER;

ALTER TABLE hunting_rewards ADD COLUMN min_village_rank INTEGER;
ALTER TABLE hunting_rewards ADD COLUMN min_guild_rank INTEGER;

ALTER TABLE quest_rewards ADD COLUMN min_village_rank INTEGER;
ALTER TABLE quest_rewards ADD COLUMN min_guild_rank INTEGER;

ALTER TABLE items ADD COLUMN min_village_rank INTEGER;
ALTER TABLE items ADD COLUMN min_guild_rank INTEGER;

ALTER TABLE components ADD COLUMN min_village_rank INTEGER;
ALTER TABLE components ADD COLUMN min_guild_rank INTEGER;

ALTER TABLE combining ADD COLUMN min_village_rank1 INTEGER;
ALTER TABLE combining ADD COLUMN min_village_rank2 INTEGER;
ALTER TABLE combining ADD COLUMN min_village_rank INTEGER;
ALTER TABLE combining ADD COLUMN min_guild_rank1 INTEGER;
ALTER TABLE combining ADD COLUMN min_guild_rank2 INTEGER;
ALTER TABLE combining ADD COLUMN min_guild_rank INTEGER;