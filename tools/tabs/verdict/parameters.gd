extends BaseParameters

var factEditPackedScene : PackedScene = preload("res://tools/tabs/verdict/factEdit.tscn")


func _ready() -> void:
	ToolSignals.factRemoved.connect(factRemoved)
	ToolSignals.factMovedUp.connect(moveFactUp)
	ToolSignals.factMovedDown.connect(moveFactDown)


func setDto(value : VerdictDTO) -> void:
	dto = value
	
	$idGrid/txtName.dto = value
	$idGrid/txtShortname.dto = value
	
	for child in $scroll/list.get_children():
		child.queue_free()
	
	for fact in value.actions:
		var factEdit = factEditPackedScene.instantiate()
		factEdit.fact = fact
		
		$scroll/list.add_child(factEdit)
	
	enumerateFacts()


func moveFactUp(node : Control) -> void:
	$scroll/list.move_child(node, clamp($scroll/list.get_children().find(node) - 1, 0, $scroll/list.get_child_count() - 1))
	enumerateFacts()
	collectFacts()


func moveFactDown(node : Control) -> void:
	$scroll/list.move_child(node, clamp($scroll/list.get_children().find(node) + 1, 0, $scroll/list.get_child_count() - 1))
	enumerateFacts()
	collectFacts()


func factRemoved(node : Control) -> void:
		enumerateFacts()
		collectFacts()
		
		node.queue_free()


func enumerateFacts() -> void:
	await get_tree().process_frame
	
	var i = 1
	for child in $scroll/list.get_children():
		child.factPosition = i
		i += 1


func collectFacts() -> void:
	await get_tree().process_frame
	
	dto.actions = []
	for child in $scroll/list.get_children():
		dto.actions.append(child.fact)


func _on_btn_add_pressed() -> void:
	$scroll/list.add_child(factEditPackedScene.instantiate())
	enumerateFacts()
	collectFacts()

