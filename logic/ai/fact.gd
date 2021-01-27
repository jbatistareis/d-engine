class_name Fact
extends Entity

const _NOOP : String = 'extends Node\nfunc result(suspects : Array) -> Array:\n\treturn []'

var analyzeScript : String


func _init(id : int, analyzeScript : String = '').(id) -> void:
	self.analyzeScript = analyzeScript if !analyzeScript.empty() else _NOOP


func analyze(suspects : Array) -> Array:
	var node = ScriptTool.getNode(analyzeScript)
	var result = node.result(suspects)
	node.queue_free()
	
	return result

