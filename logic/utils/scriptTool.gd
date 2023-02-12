class_name ScriptTool


static func getReference(script : String) -> RefCounted:
	var gdScript = GDScript.new()
	var reference : RefCounted = RefCounted.new()
	
	gdScript.set_source_code(script)
	gdScript.reload()
	
	reference.set_script(gdScript)
	
	return reference

