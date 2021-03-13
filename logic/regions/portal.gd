class_name Portal
extends Entity

const _NOOP : String = 'func execute(character : Character) -> bool:\n\treturn true'

var entranceLogic : String


func _init(id : int, entranceLogic : String = '').(id) -> void:
	self.entranceLogic = entranceLogic if !entranceLogic.empty() else _NOOP


func canPass(character : Character) -> bool:
	return ScriptTool.getReference(entranceLogic).execute(character)

