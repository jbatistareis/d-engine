extends Node

const MOVE_BASE_VALUE : String = 'func getValue(_character : Character) -> int:\n\treturn -(_character.baseDamage + _character.strength.score + _character.inventory.weapon.calculateDamage(_character))'
const MOVE_BASE_OUTCOME : String = 'func getOutcome(_character : Character) -> int:\n\treturn Enums.DiceOutcome.BEST'
const MOVE_BASE_PICK : String = 'func pick(_character : Character) -> void:\n\tpass'
const MOVE_BASE_EXECUTE : String = 'func execute(_character : Character) -> void:\n\tpass'

const LOCATION_NOOP : String = 'func execute(_character : Character) -> void:\n\treturn'
const ROOM_ENTER_NOOP : String = 'func execute(_character : Character, _direction : int) -> bool:\n\treturn true'
const ROOM_NOOP : String = 'func execute(_character : Character, _direction : int) -> void:\n\treturn'


var actionBase : Dictionary = {
	'self': Enums.Fact.ANY,
	'target': Enums.Fact.HP_HIGHEST,
	'moveShortName': 'BSEATK'
}

var roomBase : Dictionary = {
	'id': 0,
	'x': 0,
	'y': 0,
	'type': Enums.RoomType.DUMMY, # use  Enums.RoomType
	'orientation': Enums.Direction.NORTH , # use Enums.Direction
	'model': '4_exits',
	'exits': [-1, -1, -1, -1, -1, -1],
	'canEnterLogic': ROOM_ENTER_NOOP,
	'enteringLogic': ROOM_NOOP,
	'exitingLogic': ROOM_NOOP,
	'foeShortNameGroups': [], # 2D array representing possible enemy groups
	'visited': false,
}

var facts : Dictionary = {
	Enums.Fact.ANY: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn _suspects',
	Enums.Fact.HP_HIGHEST: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHighestHp(_suspects)',
	Enums.Fact.HP_LOWEST: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByLowestHp(_suspects)',
	Enums.Fact.HP_GREATER_95: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpGt(_suspects, 0.95)',
	Enums.Fact.HP_GREATER_75: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpGt(_suspects, 0.75)',
	Enums.Fact.HP_GREATER_50: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpGt(_suspects, 0.50)',
	Enums.Fact.HP_GREATER_35: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpGt(_suspects, 0.35)',
	Enums.Fact.HP_GREATER_15: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpGt(_suspects, 0.15)',
	Enums.Fact.HP_GREATER_5: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpGt(_suspects, 0.05)',
	Enums.Fact.HP_LOWER_95: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpLt(_suspects, 0.95)',
	Enums.Fact.HP_LOWER_75: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpLt(_suspects, 0.75)',
	Enums.Fact.HP_LOWER_50: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpLt(_suspects, 0.50)',
	Enums.Fact.HP_LOWER_35: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpLt(_suspects, 0.35)',
	Enums.Fact.HP_LOWER_15: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpLt(_suspects, 0.15)',
	Enums.Fact.HP_LOWER_5: 'func execute(_auditor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHpLt(_suspects, 0.05)'
}


var BitmaskDirections : Dictionary = {
	Enums.Direction.NORTH: 1,
	Enums.Direction.EAST: 2,
	Enums.Direction.SOUTH: 4,
	Enums.Direction.WEST: 8,
	Enums.Direction.UP: 16,
	Enums.Direction.DOWN: 32
}

var BimaskTileset : Dictionary = {
	# 1_exit
	1: {
		'type': Enums.RoomType._1_EXIT,
		'orientation': Enums.Direction.NORTH ,
		'model': '1_exit'
	},
	2: {
		'type': Enums.RoomType._1_EXIT,
		'orientation': Enums.Direction.EAST ,
		'model': '1_exit'
	},
	4: {
		'type': Enums.RoomType._1_EXIT,
		'orientation': Enums.Direction.SOUTH ,
		'model': '1_exit'
	},
	8: {
		'type': Enums.RoomType._1_EXIT,
		'orientation': Enums.Direction.WEST ,
		'model': '1_exit'
	},
	
	# 2_exits_I
	5: {
		'type': Enums.RoomType._2_EXITS_I,
		'orientation': Enums.Direction.NORTH ,
		'model': '2_exits_I'
	},
	10: {
		'type': Enums.RoomType._2_EXITS_I,
		'orientation': Enums.Direction.EAST ,
		'model': '2_exits_I'
	},
	
	# 2_exits_L
	3: {
		'type': Enums.RoomType._2_EXITS_L,
		'orientation': Enums.Direction.NORTH ,
		'model': '2_exits_L'
	},
	6: {
		'type': Enums.RoomType._2_EXITS_L,
		'orientation': Enums.Direction.EAST ,
		'model': '2_exits_L'
	},
	12: {
		'type': Enums.RoomType._2_EXITS_L,
		'orientation': Enums.Direction.SOUTH ,
		'model': '2_exits_L'
	},
	9: {
		'type': Enums.RoomType._2_EXITS_L,
		'orientation': Enums.Direction.WEST ,
		'model': '2_exits_L'
	},
	
	# 3_exits
	11: {
		'type': Enums.RoomType._3_EXITS,
		'orientation': Enums.Direction.NORTH ,
		'model': '3_exits'
	},
	7: {
		'type': Enums.RoomType._3_EXITS,
		'orientation': Enums.Direction.EAST ,
		'model': '3_exits'
	},
	14: {
		'type': Enums.RoomType._3_EXITS,
		'orientation': Enums.Direction.SOUTH ,
		'model': '3_exits'
	},
	13: {
		'type': Enums.RoomType._3_EXITS,
		'orientation': Enums.Direction.WEST ,
		'model': '3_exits'
	},
	
	# 4_exits
	15: {
		'type': Enums.RoomType._4_EXITS,
		'orientation': Enums.Direction.NORTH ,
		'model': '4_exits'
	}
}

