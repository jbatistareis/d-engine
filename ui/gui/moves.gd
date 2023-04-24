extends VBoxContainer


func _ready() -> void:
	Signals.battleMoveDescription.connect(
		func(text):
			$decription.visible = true
			$decription/container/lblDescription.text = text)
	
	Signals.commandPublished.connect(func(command): visible = false)
	
	Signals.battleInventoryShow.connect(
		func(character):
			for child in $cards/grid.get_children():
				child.queue_free())

