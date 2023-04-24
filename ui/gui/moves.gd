extends VBoxContainer


func _ready() -> void:
	Signals.battleMoveDescription.connect(func(text): $decription/container/lblDescription.text = text)
	Signals.battlePickedMove.connect(func(character, move): visible = false)
	Signals.battleInventoryShow.connect(
		func(character):
			for child in $cards/grid.get_children():
				child.queue_free())

