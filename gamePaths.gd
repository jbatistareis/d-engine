class_name GamePaths

const EXTENSION_REGEX : String = '\\..*'

const DATA : String = 'res://data/%s'

const _LOCATION : String = DATA % 'locations'
const _CHARACTER : String = DATA % 'characters'
const _VERDICT : String = DATA % 'verdicts'
const _FACT : String = DATA % 'facts'
const _INVENTORY : String = DATA % 'inventories'
const _ITEM : String = DATA % 'items'
const _WEAPON : String = DATA % 'weapons'
const _MOVE : String = DATA % 'moves'
const _ARMOR : String = DATA % 'armors'

const CHARACTER_DATA : String = _CHARACTER + '/%s.cha'
const VERDICT_DATA : String = _VERDICT + '/%s.vrd'
const FACT_DATA : String = _FACT + '/%s.fct'
const INVENTORY_DATA : String = _INVENTORY + '/%s.inv'
const ITEM_DATA : String = _ITEM + '/%s.itm'
const WEAPON_DATA : String = _WEAPON + '/%s.wpn'
const MOVE_DATA : String = _MOVE + '/%s.mov'
const ARMOR_DATA : String = _ARMOR + '/%s.arm'
const LOCATION_DATA : String = _LOCATION + '/%s.loc'
const MAP_DATA : String = _LOCATION + '/%s/'

const CHARACTER_MODEL : String = _CHARACTER + '/%s/characterModel.tscn'

