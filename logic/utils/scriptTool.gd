extends Node


static func getReference(script : String) -> Reference:
	var gdScript = GDScript.new()
	var reference : Reference = Reference.new()
	
	gdScript.set_source_code(script)
	gdScript.reload()
	
	reference.set_script(gdScript)
	
	return reference

