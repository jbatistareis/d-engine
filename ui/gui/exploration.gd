extends Control

const _STATUS_TEXT : String = '[center][\t%s\t][/center]\n[table=3][cell]HP[/cell][cell]\t[/cell][cell]%d/%d[/cell][cell]LV[/cell][cell]\t[/cell][cell]%d[/cell][cell]Pts.[/cell][cell]\t[/cell][cell]%d[/cell][cell]Next[/cell][cell]\t[/cell][cell]%d/%d[/cell][/table]\n[center]- - - - -[/center]\n[table=3][cell]Strength[/cell][cell]\t[/cell][cell]%d[/cell][cell]Dexterity[/cell][cell]\t[/cell][cell]%d[/cell][cell]Constitution[/cell][cell]\t[/cell][cell]%d[/cell][cell]Intelligence[/cell][cell]\t[/cell][cell]%d[/cell][cell]Wisdom[/cell][cell]\t[/cell][cell]%d[/cell][cell]Charisma[/cell][cell]\t[/cell][cell]%d[/cell][/table]'


func _ready() -> void:
	Signals.connect("guiOpenExploringMenu", self, "show")
	Signals.connect("guiCloseExploringMenu", self, "hide")


func focus() -> void:
	show()


func unfocus() -> void:
	$menuContainer/menu.visible = false


func show() -> void:
	visible = true
	$menuContainer/menu.visible = true
	
	$menuContainer/menu/items/btnAction.grab_focus()
	
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
	


func hide() -> void:
	visible = false


# buttons
func _on_btnAction_pressed():
	pass # Replace with function body.


func _on_btnMap_pressed():
	pass # Replace with function body.


func _on_btnItems_pressed():
	$inventory.showWindow(GameManager.player)


func _on_btnEquip_pressed():
	pass # Replace with function body.


func _on_btnMoves_pressed():
	pass # Replace with function body.

func _on_btnClose_pressed():
	Signals.emit_signal("guiCloseExploringMenu")

