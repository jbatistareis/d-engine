extends VBoxContainer

var actionPkdScn : PackedScene = preload("res://tools/character/action/action.tscn")
var verdictDto : VerdictDTO


func loadData(verdictDto : VerdictDTO) -> void:
	self.verdictDto = verdictDto
	$identification/lblVrdName.text = verdictDto.name
	
	for child in $scroll/container.get_children():
		child.queue_free()
	
	var index = 1
	for action in verdictDto.actions:
		var card = actionPkdScn.instance()
		card.action = action
		card.index = index
		index =+ 1
		
		$scroll/container.add_child(card)


func _on_btnEditVerdict_pressed():
	EditorSignals.emit_signal("selectedVerdict", verdictDto.shortName)

