extends PopupMenu

var lastBtnIdx : int = 0


func _ready() -> void:
	set_item_submenu(0, "map")
	set_item_submenu(1, "inventory")
	set_item_submenu(2, "wpnPartyMenu")


func _on_index_pressed(index: int) -> void:
	match index:
		3: Signals.emit_signal("guiCloseExploringMenu")


func _on_wpn_party_menu_menu_changed() -> void:
	for i in range($wpnPartyMenu.item_count):
		$wpnPartyMenu.set_item_submenu(i, "weapons")

