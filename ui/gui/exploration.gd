extends Control

var statsScene : PackedScene = preload("res://ui/gui/stats.tscn") 
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
	for stat in $party.get_children():
		stat.queue_free()
	
	for character in GameManager.party:
		var stats = statsScene.instance()
		stats.setCharacter(character)
		$party.add_child(stats)
	
	visible = true
	focus()


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
			$inventory.showWindow(GameManager.player)
		2:
			$weapons.showWindow()
		_:
			Signals.emit_signal("guiCloseExploringMenu")
	
	if !Signals.is_connected("guiBack", self, "focus"):
		Signals.connect("guiBack", self, "focus")


func _on_btnMap_pressed() -> void:
	buttonPressed(0)


func _on_btnItems_pressed() -> void:
	buttonPressed(1)


func _on_btnEquip_pressed() -> void:
	buttonPressed(2)


func _on_btnClose_pressed() -> void:
	buttonPressed(3)

