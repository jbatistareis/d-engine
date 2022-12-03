extends Control

const _STATUS_TEXT : String = '[center][\t%s\t][/center]\n[table=3][cell]HP[/cell][cell]\t[/cell][cell]%d/%d[/cell][cell]LV[/cell][cell]\t[/cell][cell]%d[/cell][cell]Pts.[/cell][cell]\t[/cell][cell]%d[/cell][cell]Next[/cell][cell]\t[/cell][cell]%d/%d[/cell][/table]\n[center]- - - - -[/center]\n[table=3][cell]Strength[/cell][cell]\t[/cell][cell]%d[/cell][cell]Dexterity[/cell][cell]\t[/cell][cell]%d[/cell][cell]Constitution[/cell][cell]\t[/cell][cell]%d[/cell][cell]Intelligence[/cell][cell]\t[/cell][cell]%d[/cell][cell]Wisdom[/cell][cell]\t[/cell][cell]%d[/cell][cell]Charisma[/cell][cell]\t[/cell][cell]%d[/cell][/table]'


func _ready() -> void:
	Signals.connect("guiOpenExploringMenu", self, "show")
	Signals.connect("guiCloseExploringMenu", self, "hide")


func focus() -> void:
	if Signals.is_connected("guiBack", self, "focus"):
		Signals.disconnect("guiBack", self, "focus")
	
	$menuContainer/menu.modulate = $menuContainer/menu.modulate.lightened(1)
	$menuContainer/menu.grab_focus()


func show() -> void:
	visible = true
	$menuContainer/menu.rect_position = $menuContainer/stats.rect_global_position + Vector2($menuContainer/stats.rect_size.x + 10, 0)
	$menuContainer/menu.popup()
	focus()
	
	$menuContainer/stats/lblStats.bbcode_text = _STATUS_TEXT % [
			GameManager.player.name,
			GameManager.player.currentHp,
			GameManager.player.maxHp,
			GameManager.player.currentLevel,
			GameManager.player.sparePoints,
			GameManager.player.experiencePoints,
			GameManager.player.experienceToNextLevel,
			GameManager.player.strength.score,
			GameManager.player.dexterity.score,
			GameManager.player.constitution.score,
			GameManager.player.intelligence.score,
			GameManager.player.wisdom.score,
			GameManager.player.charisma.score
		]
	$menuContainer/stats/lblStats.bbcode_enabled = true


func _on_menu_about_to_show() -> void:
	$menuContainer/menu.set_current_index(0)


func hide() -> void:
	$menuContainer/menu.hide()
	visible = false


# buttons
func _on_PopupMenu_id_pressed(id : int) -> void:
	$menuContainer/menu.modulate = $menuContainer/menu.modulate.darkened(0.25)
	
	match id:
		0:
			pass
		1:
			pass
		2:
			$inventory.showWindow(GameManager.player)
		3:
			$equipment.showWindow(GameManager.player)
		4:
			pass
		_:
			Signals.emit_signal("guiCloseExploringMenu")
	
	if !Signals.is_connected("guiBack", self, "focus"):
		Signals.connect("guiBack", self, "focus")

