extends Node


static func getNode(script : String) -> Node:
	var gdScript = GDScript.new()
	var node : Node = Node.new()
	
	gdScript.set_source_code(script)
	gdScript.reload()
	
	node.set_script(gdScript)
	
	return node

