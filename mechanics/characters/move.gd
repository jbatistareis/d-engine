class_name Move
extends Entity

const INTERNAL_SCRIPT : String = 'func get_value(character : Character) -> int:\n\treturn %s\nfunc get_outcome(character : Character) -> int:\n\treturn Dice.get_outcome(%s)'

var name : String setget ,getName
var description : String setget ,getDescription
var _valueExpression : String
var _outcomeExpression : String
var cdPre : int setget ,getCdPre
var cdPost : int setget ,getCdPost


func _init(id : int, name : String, description : String, valueExpression : String, outcomeExpression : String, cdPre : int, cdPost : int).(id) -> void:
	self.name = name
	self.description = description
	self._valueExpression = valueExpression
	self._outcomeExpression = outcomeExpression
	self.cdPre = cdPre
	self.cdPost = cdPost


func getName() -> String:
	return name


func getDescription() -> String:
	return description


func getCdPre() -> int:
	return cdPre


func getCdPost() -> int:
	return cdPost


func getResult(character : Character) -> MoveResult:
	var reference = ScriptTool.get_reference(INTERNAL_SCRIPT % [CharacterScriptParser.parse(_valueExpression), CharacterScriptParser.parse(_outcomeExpression)])
	var result = MoveResult.new(reference.getValue(character), reference.getOutcome(character))
	
	reference.free()
	
	return result
