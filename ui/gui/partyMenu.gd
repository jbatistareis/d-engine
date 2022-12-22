extends PopupMenu


func _ready() -> void:
	Signals.connect("guiPopupPartyMenu", self, "showMenu")
	Signals.connect("guiHidePartyMenu", self, "hide")


func showMenu(position : Vector2) -> void:
	Signals.connect("guiCancel", self, "hide")
	Signals.connect("guiCloseExploringMenu", self, "hide")
	
	clear()
	
	for character in GameManager.party:
		add_item(' ' + character.name + ' ')
	
	rect_position = position
	popup()
	
	grab_focus()
	set_current_index(0)


func _on_partyMenu_id_pressed(id : int) -> void:
	Signals.emit_signal("guiPartyMenuPick", id)


func _on_partyMenu_hide() -> void:
	Signals.disconnect("guiCancel", self, "hide")
	Signals.disconnect("guiCloseExploringMenu", self, "hide")
	Signals.emit_signal("guiPartyMenuHidden")

