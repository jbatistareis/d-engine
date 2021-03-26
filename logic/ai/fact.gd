class_name Fact

const _NOOP : String = 'func execute(suspects : Array) -> Array:\n\treturn []'

var analyzeScript : String = _NOOP


func analyze(suspects : Array) -> Array:
	return ScriptTool.getReference(analyzeScript).execute(suspects)

