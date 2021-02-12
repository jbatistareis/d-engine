class_name Fact
extends Entity

const _NOOP : String = 'func execute(suspects : Array) -> Array:\n\treturn []'

var analyzeScript : String


func _init(id : int, analyzeScript : String = '').(id) -> void:
	self.analyzeScript = analyzeScript if !analyzeScript.empty() else _NOOP


func analyze(suspects : Array) -> Array:
	return ScriptTool.getReference(analyzeScript).execute(suspects)

