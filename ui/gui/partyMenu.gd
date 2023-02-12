extends PopupMenu


func _ready() -> void:
	Signals.guiPopupPartyMenu.connect(showMenu)
	Signals.guiHidePartyMenu.connect(hide)


func showMenu(position : Vector2) -> void:
	Signals.guiCancel.connect(hide)
	Signals.guiCloseExploringMenu.connect(hide)
	
	clear()
	
	for character in GameManager.party:
		add_item(' ' + character.name + ' ')
	
	position = position
	popup()
	
	grab_focus()
	set_focused_item(0)


func _on_partyMenu_id_pressed(id : int) -> void:
	Signals.guiPartyMenuPick.emit(id)


func _on_partyMenu_hide() -> void:
	Signals.guiCancel.disconnect(hide)
	Signals.guiCloseExploringMenu.disconnect(hide)
	Signals.guiPartyMenuHidden.emit()

