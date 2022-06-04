extends Node

const MOVE_BASE_VALUE : String = 'func getValue(_character : Character) -> int:\n\treturn -(_character.baseDamage + _character.strength.score + _character.inventory.weapon.calculateDamage(_character))'
const MOVE_BASE_OUTCOME : String = 'func getOutcome(_character : Character) -> int:\n\treturn Enums.DiceOutcome.BEST'
const MOVE_BASE_PICK : String = 'func pick(_character : Character) -> void:\n\tpass'
const MOVE_BASE_EXECUTE : String = 'func execute(_character : Character) -> void:\n\tpass'

const LOCATION_NOOP : String = 'func execute(_character : Character) -> void:\n\treturn'
const ROOM_ENTER_NOOP : String = 'func execute(_character : Character, _direction : int) -> bool:\n\treturn true'
const ROOM_NOOP : String = 'func execute(_character : Character, _direction : int) -> void:\n\treturn'


var actionBase : Dictionary = {
	'fact': Enums.Fact.HP_HIGHEST,
	'moveShortName': 'BSEATK'
}

var roomBase : Dictionary = {
	'id': 0,
	'x': 0,
	'y': 0,
	'type': Enums.RoomType._4_EXITS, # use  Enums.RoomType
	'orientation': Enums.Direction.NORTH , # use Enums.Direction
	'model': '4_exits',
	'exits': [-1, -1, -1, -1, -1, -1],
	'canEnterLogic': ROOM_ENTER_NOOP,
	'enteringLogic': ROOM_NOOP,
	'exitingLogic': ROOM_NOOP,
	'foeShortNameGroups': [], # 2D array representing possible enemy groups
	'visited': false,
}

var facts : Dictionary ={
	Enums.Fact.HP_HIGHEST: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHighestHp(_suspects)',
	Enums.Fact.HP_LOWEST: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByLowestHp(_suspects)',
	Enums.Fact.HP_GREATER_95: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpGt(_suspects, 0.95)',
	Enums.Fact.HP_GREATER_75: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpGt(_suspects, 0.75)',
	Enums.Fact.HP_GREATER_50: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpGt(_suspects, 0.50)',
	Enums.Fact.HP_GREATER_35: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpGt(_suspects, 0.35)',
	Enums.Fact.HP_GREATER_15: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpGt(_suspects, 0.15)',
	Enums.Fact.HP_GREATER_5: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpGt(_suspects, 0.05)',
	Enums.Fact.HP_LOWER_95: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpLt(_suspects, 0.95)',
	Enums.Fact.HP_LOWER_75: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpLt(_suspects, 0.75)',
	Enums.Fact.HP_LOWER_50: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpLt(_suspects, 0.50)',
	Enums.Fact.HP_LOWER_35: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpLt(_suspects, 0.35)',
	Enums.Fact.HP_LOWER_15: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpLt(_suspects, 0.15)',
	Enums.Fact.HP_LOWER_5: 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpLt(_suspects, 0.05)'
}

