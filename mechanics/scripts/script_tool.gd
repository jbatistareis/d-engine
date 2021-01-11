extends Node


# TODO
static func execute(script : String, characterSpawnId : int) -> void:
	if script.empty():
		return
	pass


static func getReference(script : String) -> Reference:
	var gdScript = GDScript.new()
	var reference = Reference.new()
	
	gdScript.set_source_code(script)
	gdScript.reload()
	
	reference.set_script(gdScript)
	
	return reference

