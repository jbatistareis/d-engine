class_name Fact

const _NOOP : String = 'func execute(executor : Character, suspects : Array) -> Array:\n\treturn []'

var analyzeScript : String = _NOOP


func analyze(auditorCharacter, suspects : Array) -> Array:
	return ScriptTool.getReference(analyzeScript).execute(auditorCharacter, suspects)

