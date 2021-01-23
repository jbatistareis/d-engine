class_name Move
extends Entity

const _INTERNAL_SCRIPT : String = 'extends Node\nfunc getValue(character : Character) -> int:\n\treturn %s\nfunc getOutcome(character : Character) -> int:\n\treturn Dice.getOutcome(%s)'

var name : String
var description : String
var _valueExpression : String
var _outcomeExpression : String
var cdPre : int
var cdPost : int


func _init(id : int, name : String, description : String, valueExpression : String, outcomeExpression : String, cdPre : int, cdPost : int).(id) -> void:
	self.name = name
	self.description = description
	self._valueExpression = valueExpression
	self._outcomeExpression = outcomeExpression
	self.cdPre = cdPre
	self.cdPost = cdPost


func getResult(character : Character) -> MoveResult:
	var node = ScriptTool.getNode(_INTERNAL_SCRIPT % [CharacterScriptParser.parse(_valueExpression), CharacterScriptParser.parse(_outcomeExpression)])
	var result = MoveResult.new(node.getValue(character), node.getOutcome(character))
	node.free()
	
	return result

