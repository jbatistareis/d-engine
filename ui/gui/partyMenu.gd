extends PopupMenu


func _on_about_to_popup() -> void:
	clear()
	
	for character in GameManager.party:
		add_item(character.name)
	
	position = position
	
	grab_focus()
	set_focused_item(0)


func _on_partyMenu_id_pressed(id : int) -> void:
	Signals.guiPartyMenuPick.emit(id)

