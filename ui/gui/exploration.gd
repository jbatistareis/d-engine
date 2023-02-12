extends HBoxContainer

var statsScene : PackedScene = preload("res://ui/gui/stats.tscn") 


func _ready() -> void:
	Signals.guiOpenExploringMenu.connect(showMenus)
	Signals.guiCloseExploringMenu.connect(hideMenus)


func showMenus() -> void:
	for stat in $statusSide.get_children():
		stat.queue_free()
	
	for character in GameManager.party:
		var stats = statsScene.instantiate()
		stats.setCharacter(character)
		$statusSide.add_child(stats)
	show()
	
	$menuSide/menu.position = $menuSide.position + Vector2(5, 0)
	$menuSide/menu.popup()
	$menuSide/menu.set_focused_item(0)
	$menuSide/menu.grab_focus()


# TODO remove this wasp nest
func hideMenus() -> void:
	for panel in $menuSide/menu.get_children():
		for menu in panel.get_children():
			for submenu in menu.get_children():
				for subsubmenu in submenu.get_children():
					subsubmenu.hide()
				submenu.hide()
			menu.hide()
		panel.hide()
	$menuSide/menu.hide()
	
	hide()

