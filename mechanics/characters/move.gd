class_name Move
extends Entity

const _INTERNAL_MOVE_SCRIPT : String = 'extends Node\n%s\n%s'
const _INTERNAL_MOVE_SCRIPT_NOOP_VALUE : String = 'func getValue(character : Character) -> int:\n\treturn 0'
const _INTERNAL_MOVE_SCRIPT_NOOP_OUTCOME : String = 'func getOutcome(character : Character) -> int:\n\treturn 1'

var name : String
var description : String
var valueExpression : String
var outcomeExpression : String
var cdPre : int
var cdPost : int


func _init(id : int, name : String, description : String, valueExpression : String, outcomeExpression : String, cdPre : int, cdPost : int).(id) -> void:
	self.name = name
	self.description = description
	self.valueExpression = valueExpression if !valueExpression.empty() else _INTERNAL_MOVE_SCRIPT_NOOP_VALUE
	self.outcomeExpression = outcomeExpression if !outcomeExpression.empty() else _INTERNAL_MOVE_SCRIPT_NOOP_OUTCOME
	self.cdPre = cdPre
	self.cdPost = cdPost


func getResult(character : Character) -> MoveResult:
	var node = ScriptTool.getNode(_INTERNAL_MOVE_SCRIPT % [valueExpression, valueExpression])
	var result = MoveResult.new(node.getValue(character), node.getOutcome(character))
	node.queue_free()
	
	return result

