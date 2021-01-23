class_name Fact
extends Entity

const _INTERNAL_SCRIPT_NOOP : String = 'extends Node\nfunc result(suspectsSpawnIds : Array) -> Array:\n\treturn []'

var analyzeScript : String


func _init(id : int, analyzeScript : String = '').(id) -> void:
	self.analyzeScript = analyzeScript if !analyzeScript.empty() else _INTERNAL_SCRIPT_NOOP


# TODO test if it works with arrays
func analyze(suspectsSpawnIds : Array) -> Array:
	var node = ScriptTool.getNode(analyzeScript)
	var result = node.result(suspectsSpawnIds)
	node.free()
	
	return result

