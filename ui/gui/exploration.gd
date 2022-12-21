extends Control

const _STATUS_TEXT : String = '[center][\t%s\t][/center]\n[table=3][cell]HP[/cell][cell]\t[/cell][cell]%d/%d[/cell][cell]LV[/cell][cell]\t[/cell][cell]%d[/cell][cell]Pts.[/cell][cell]\t[/cell][cell]%d[/cell][cell]Next[/cell][cell]\t[/cell][cell]%d/%d[/cell][/table]\n[center]- - - - -[/center]\n[table=3][cell]Strength[/cell][cell]\t[/cell][cell]%d[/cell][cell]Dexterity[/cell][cell]\t[/cell][cell]%d[/cell][cell]Constitution[/cell][cell]\t[/cell][cell]%d[/cell][cell]Intelligence[/cell][cell]\t[/cell][cell]%d[/cell][cell]Wisdom[/cell][cell]\t[/cell][cell]%d[/cell][cell]Charisma[/cell][cell]\t[/cell][cell]%d[/cell][/table]'

var lastBtnIdx : int = 0


func _ready() -> void:
	Signals.connect("guiOpenExploringMenu", self, "show")
	Signals.connect("guiCloseExploringMenu", self, "hide")


func focus() -> void:
	if Signals.is_connected("guiBack", self, "focus"):
		Signals.disconnect("guiBack", self, "focus")
	
	for btn in $menu/box.get_children():
		btn.disabled = false
		btn.focus_mode = Control.FOCUS_ALL
		btn.mouse_filter = Control.MOUSE_FILTER_STOP
	
	$menu/box.get_child(lastBtnIdx).grab_focus()


func show() -> void:
	visible = true
	focus()
	
	$stats/lblStats.bbcode_text = _STATUS_TEXT % [
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
	$stats/lblStats.bbcode_enabled = true


func hide() -> void:
	visible = false
	lastBtnIdx = 0


# buttons
func buttonPressed(id : int) -> void:
	lastBtnIdx = id
	
	for idx in range($menu/box.get_child_count()):
		$menu/box.get_child(idx).disabled = (idx != id)
		$menu/box.get_child(idx).focus_mode = Control.FOCUS_NONE
		$menu/box.get_child(idx).mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	match id:
		0:
			pass
		1:
			pass
		2:
			# TODO show party
			$inventory.showWindow(GameManager.player)
		3:
			# TODO show party
			$equipment.showWindow()
		4:
			pass
		_:
			Signals.emit_signal("guiCloseExploringMenu")
	
	if !Signals.is_connected("guiBack", self, "focus"):
		Signals.connect("guiBack", self, "focus")


func _on_btnAction_pressed() -> void:
	buttonPressed(0)


func _on_btnMap_pressed() -> void:
	buttonPressed(1)


func _on_btnItems_pressed() -> void:
	buttonPressed(2)


func _on_btnEquip_pressed() -> void:
	buttonPressed(3)


func _on_btnMoves_pressed() -> void:
	buttonPressed(4)


func _on_btnClose_pressed() -> void:
	buttonPressed(5)

