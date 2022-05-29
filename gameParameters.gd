extends Node

const GCD : float = 0.25
const WAIT_TICKS : int = 20


const MOVE_BASE_VALUE : String = 'func getValue(_character : Character) -> int:\n\treturn -(character.baseDamage + character.strength.score + character.inventory.weapon.calculateDamage(character))'
const MOVE_BASE_OUTCOME : String = 'func getOutcome(_character : Character) -> int:\n\treturn Enums.DiceOutcome.BEST'
const MOVE_BASE_PICK : String = 'func pick(_character : Character) -> void:\n\tpass'
const MOVE_BASE_EXECUTE : String = 'func execute(_character : Character) -> void:\n\tpass'

const FACT_BASE : String = 'func execute(_executor : Character, _suspects : Array) -> Array:\n\treturn CharacterQuery.findByHighestHp(suspects)'

const LOCATION_NOOP : String = 'func execute(_character : Character) -> void:\n\treturn'
const PORTAL_NOOP : String = 'func execute(_character : Character) -> bool:\n\treturn true'
const ROOM_TILE_NOOP : String = 'func execute(_character : Character) -> void:\n\treturn'


var actionBase : Dictionary = {
	'factShortName': 'HGHPEN',
	'moveShortName': 'BSEATK'
}

var roomBase : Dictionary = {
	'id': 0,
	'x': 0,
	'y': 0,
	'type': Enums.RoomType._4_EXITS, # use  Enums.RoomType
	'orientation': Enums.Direction.NORTH , # use Enums.Direction
	'mesh': '4_exits',
	'exits': [0, 0, 0, 0, 0, 0],
	'portals': [0, 0, 0, 0, 0, 0],
	'entranceLogic': ROOM_TILE_NOOP,
	'exitLogic': ROOM_TILE_NOOP,
	'friendlyShortNames': [], # short names of NPCs present in the room
	'foeShortNameGroups': [], # 2D array representing possible enemy groups
	'visited': false,
}

var portalBase : Dictionary = {
	'id': 1,
	'passLogic': PORTAL_NOOP,
	'newLocationShortName': '',
	'toSpawnId': 2
}

var spwanBase : Dictionary = {
	'id': 2,
	'direction': Enums.Direction.NORTH,
	'toRoomId': 0
}

