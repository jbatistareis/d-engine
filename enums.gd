class_name Enums

enum EntityType { CHARACTER, MOVE, VERDICT, FACT, INVENTORY, ITEM, WEAPON, ARMOR, LOCATION }

enum States { BOOT, TITLE, MAIN_MENU, EXPLORING, EXPLORING_MENU, BATTLE, INVENTORY, EQUIPMENT }

enum DiceType { D4 = 4, D6 = 6, D8 = 8, D10 = 10, D12 = 12, D20 = 20, D100 = 100 }
enum DiceOutcome { BEST, WITH_CONSEQUENCE, WORST }
enum DiceRollType { NONE, BEST, NORMAL, WORST }

enum CharacterAbility { NONE, STRENGTH, DEXTERITY, CONSTITUTION, INTELLIGENCE, WISDOM, CHARISMA }
enum CharacterModifier { NONE, STR, DEX, CON, INT, WIS, CHA }
enum CharacterType { PC, NPC, FOE }
enum CharacterTargetType { NONE, ANY, FRIENDLY, FOE, FOE_ALL }

enum MoveModifierProperty { NONE, ATK_P, DEF_P, CD_P, ATK_M, DEF_M, CD_M }

enum ItemType { CONSUMABLE, TOOL, KEY }

enum RoomType { _0_EXIT, _1_EXIT, _2_EXITS_I, _2_EXITS_L, _3_EXITS, _4_EXITS }
enum Direction { NORTH, EAST, SOUTH, WEST, UP, DOWN, FORWARD, BACKWARD, LEFT, RIGHT, NONE }

enum AfflictionType { TODO }

enum MessageType { AUTO_TOP, AUTO_BOTTOM, DIALOG }

enum GuiAction { NEW_WINDOW, CONFIRM, CANCEL, SLIDE, PREVIOUS, NEXT, TOGGLE }

enum GuiWindowType { FOREGROUND, BACKGROUND, PERMANENT }

