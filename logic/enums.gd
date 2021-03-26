extends Node

enum DiceType { D4 = 4, D6 = 6, D8 = 8, D10 = 10, D12 = 12, D20 = 20, D100 = 100 }
enum DiceOutcome { BEST, WITH_CONSEQUENCE, WORST }
enum DiceRollType { BEST, NORMAL, WORST }

enum CharacterAbility { NONE, STRENGTH, DEXTERITY, CONSTITUTION, INTELLIGENCE, WISDOM, CHARISMA }
enum CharacterModifier { NONE, STR, DEX, CON, INT, WIS, CHA }
enum CharacterType { PC, FRIENDLY_NPC, FOE_NPC }

enum ItemType { ARMOR, WEAPON, CONSUMABLE, KEY }

enum RoomType { _0_EXIT, _1_EXIT, _2_EXITS_L, _2_EXITS_I, _3_EXITS, _4_EXITS }
enum RoomDirection { NORTH, EAST, SOUTH, WEST, UP, DOWN }

enum PortalType { ROOM, LOCATION }

enum AfflictionType { TODO }

enum MessageType { AUTO_TOP, AUTO_BOTTOM, DIALOG }

