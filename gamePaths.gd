class_name GamePaths

const EXTENSION_REGEX : String = '\\..*'

const DATA_PATH : String = 'res://data/%s'

const CHARACTER_PATH : String = DATA_PATH % 'characters'
const VERDICT_PATH : String = DATA_PATH % 'verdicts'
const INVENTORY_PATH : String = DATA_PATH % 'inventories'
const ITEM_PATH : String = DATA_PATH % 'items'
const WEAPON_PATH : String = DATA_PATH % 'weapons'
const MOVE_PATH : String = DATA_PATH % 'moves'
const ARMOR_PATH : String = DATA_PATH % 'armors'
const LOCATION_PATH : String = DATA_PATH % 'locations'

const CHARACTER_DATA : String = CHARACTER_PATH + '/%s.cha'
const VERDICT_DATA : String = VERDICT_PATH + '/%s.vrd'
const INVENTORY_DATA : String = INVENTORY_PATH + '/%s.inv'
const ITEM_DATA : String = ITEM_PATH + '/%s.itm'
const WEAPON_DATA : String = WEAPON_PATH + '/%s.wpn'
const MOVE_DATA : String = MOVE_PATH + '/%s.mov'
const ARMOR_DATA : String = ARMOR_PATH + '/%s.arm'
const LOCATION_DATA : String = LOCATION_PATH + '/%s.loc'

const CHARACTER_MODEL : String = CHARACTER_PATH + '/%s/characterModel.tscn'
const LOCATION_MODELS : String = LOCATION_PATH + '/%s/'

