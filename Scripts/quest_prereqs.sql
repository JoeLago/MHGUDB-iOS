

CREATE TABLE "quest_prereqs" (
"quest_id" integer NOT NULL,
"prereq_id" integer NOT NULL,
FOREIGN KEY ("quest_id") REFERENCES "quests"("_id"),
FOREIGN KEY ("prereq_id") REFERENCES "quests"("_id")
);
INSERT INTO "quest_prereqs" VALUES (105, 101);
INSERT INTO "quest_prereqs" VALUES (203, 219);
INSERT INTO "quest_prereqs" VALUES (204, 224);
INSERT INTO "quest_prereqs" VALUES (205, 229);
INSERT INTO "quest_prereqs" VALUES (221, 219);
INSERT INTO "quest_prereqs" VALUES (222, 219);
INSERT INTO "quest_prereqs" VALUES (223, 219);
INSERT INTO "quest_prereqs" VALUES (226, 224);
INSERT INTO "quest_prereqs" VALUES (227, 224);
INSERT INTO "quest_prereqs" VALUES (228, 224);
INSERT INTO "quest_prereqs" VALUES (231, 229);
INSERT INTO "quest_prereqs" VALUES (232, 229);
INSERT INTO "quest_prereqs" VALUES (234, 229);
INSERT INTO "quest_prereqs" VALUES (332, 308);
INSERT INTO "quest_prereqs" VALUES (332, 309);
INSERT INTO "quest_prereqs" VALUES (339, 308);
INSERT INTO "quest_prereqs" VALUES (339, 309);
INSERT INTO "quest_prereqs" VALUES (100301, 100202);
INSERT INTO "quest_prereqs" VALUES (100302, 100301);
INSERT INTO "quest_prereqs" VALUES (100303, 100301);
INSERT INTO "quest_prereqs" VALUES (100304, 100301);
INSERT INTO "quest_prereqs" VALUES (100305, 100301);
INSERT INTO "quest_prereqs" VALUES (403, 415);
INSERT INTO "quest_prereqs" VALUES (410, 422);
INSERT INTO "quest_prereqs" VALUES (421, 426);
INSERT INTO "quest_prereqs" VALUES (100401, 100306);
INSERT INTO "quest_prereqs" VALUES (100402, 100401);
INSERT INTO "quest_prereqs" VALUES (100403, 100401);
INSERT INTO "quest_prereqs" VALUES (100404, 100401);
INSERT INTO "quest_prereqs" VALUES (100501, 100405);
INSERT INTO "quest_prereqs" VALUES (100501, 100406);
INSERT INTO "quest_prereqs" VALUES (100502, 100501);
INSERT INTO "quest_prereqs" VALUES (100503, 100501);
INSERT INTO "quest_prereqs" VALUES (100504, 100501);
INSERT INTO "quest_prereqs" VALUES (612, 610);
INSERT INTO "quest_prereqs" VALUES (618, 619);
INSERT INTO "quest_prereqs" VALUES (621, 620);
INSERT INTO "quest_prereqs" VALUES (638, 636);
INSERT INTO "quest_prereqs" VALUES (638, 637);
INSERT INTO "quest_prereqs" VALUES (100601, 100505);
INSERT INTO "quest_prereqs" VALUES (100602, 100601);
INSERT INTO "quest_prereqs" VALUES (100603, 100601);
INSERT INTO "quest_prereqs" VALUES (100604, 100601);
INSERT INTO "quest_prereqs" VALUES (508, 324);
INSERT INTO "quest_prereqs" VALUES (324, 323);
INSERT INTO "quest_prereqs" VALUES (323, 224);
INSERT INTO "quest_prereqs" VALUES (224, 225);
INSERT INTO "quest_prereqs" VALUES (219, 220);
INSERT INTO "quest_prereqs" VALUES (318, 219);
INSERT INTO "quest_prereqs" VALUES (319, 318);
INSERT INTO "quest_prereqs" VALUES (504, 319);
INSERT INTO "quest_prereqs" VALUES (229, 230);
INSERT INTO "quest_prereqs" VALUES (328, 229);
INSERT INTO "quest_prereqs" VALUES (329, 328);
INSERT INTO "quest_prereqs" VALUES (510, 329);
