extends PopupMenu

var lastBtnIdx : int = 0


func _ready() -> void:
	set_item_submenu(0, "map")
	set_item_submenu(1, "inventory")
	set_item_submenu(2, "equipment")


func _on_index_pressed(index: int) -> void:
	match index:
		3: Signals.emit_signal("guiCloseExploringMenu")
		_: return

