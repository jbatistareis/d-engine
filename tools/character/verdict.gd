extends VBoxContainer

var actionPkdScn : PackedScene = preload("res://tools/character/action/action.tscn")


func loadData(verdictDto : VerdictDTO) -> void:
	$identification/lblVrdName.text = verdictDto.name
	
	for child in $scroll/container.get_children():
		child.queue_free()
	
	for action in verdictDto.actions:
		var card = actionPkdScn.instance()
		card.action = action
		
		$scroll/container.add_child(card)


func _on_btnEditVerdict_pressed():
	pass # Replace with function body.

