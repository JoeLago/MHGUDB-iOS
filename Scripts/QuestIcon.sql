ALTER TABLE quests ADD COLUMN icon_name;

UPDATE quests SET icon_name = 'Quest-Icon-White.png';
UPDATE quests SET icon_name = (SELECT items.icon_name FROM items WHERE quests.goal LIKE '%'||items.name||'%')
WHERE quests.icon_name IS NULL OR EXISTS (SELECT items.icon_name FROM items WHERE quests.goal LIKE '%'||items.name||'%');
UPDATE quests SET icon_name = (SELECT monsters.icon_name FROM monsters WHERE quests.goal LIKE '%'||monsters.name||'%')
WHERE quests.icon_name IS NULL OR EXISTS (SELECT monsters.icon_name FROM monsters WHERE quests.goal LIKE '%'||monsters.name||'%');

SELECT * FROM quests;