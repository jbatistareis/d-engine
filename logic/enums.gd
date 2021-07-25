class_name Enums

enum States { BOOT, IDLE, MAIN_MENU, GAME_MENU, BATTLE_MENU, INVENTORY, EQUIPMENT, MOVE_BACKWARD, MOVE_FORWARD, ROTATE_LEFT, ROTATE_RIGHT, TITLE }

enum DiceType { D4 = 4, D6 = 6, D8 = 8, D10 = 10, D12 = 12, D20 = 20, D100 = 100 }
enum DiceOutcome { BEST, WITH_CONSEQUENCE, WORST }
enum DiceRollType { BEST, NORMAL, WORST }

enum CharacterAbility { NONE, STRENGTH, DEXTERITY, CONSTITUTION, INTELLIGENCE, WISDOM, CHARISMA }
enum CharacterModifier { NONE, STR, DEX, CON, INT, WIS, CHA }
enum CharacterType { PC, FRIENDLY_NPC, FOE_NPC }
enum CharacterTargetType { ANY, FRIENDLY, FOE }

enum ItemType { ARMOR, WEAPON, CONSUMABLE, KEY }

enum RoomType { _0_EXIT, _1_EXIT, _2_EXITS_I, _2_EXITS_L, _3_EXITS, _4_EXITS }
enum Direction { NORTH, EAST, SOUTH, WEST, UP, DOWN }

enum AfflictionType { TODO }

enum MessageType { AUTO_TOP, AUTO_BOTTOM, DIALOG }

enum GuiAction { NEW_WINDOW, CONFIRM, CANCEL, SLIDE, PREVIOUS, NEXT, TOGGLE }

enum GuiWindowType { FOREGROUND, BACKGROUND, PERMANENT }

