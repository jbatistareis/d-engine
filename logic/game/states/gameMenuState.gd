class_name GameMenuState
extends State


func _init() -> void:
	# TODO create a proper class
	var menu1 = GuiWindowModel.new()
	var menu2 = GuiWindowModel.new()
	var menu3 = GuiWindowModel.new()
	
	var button1 = GuiButtonModel.new('TEST 1', Enums.GuiAction.NEW_WINDOW, menu2)
	var button2 = GuiButtonModel.new('TEST 2')
	var button3 = GuiButtonModel.new('TEST 3')
	var button4 = GuiButtonModel.new('TEST 4')
	
	var button5 = GuiButtonModel.new('< Back')
	
	var text1 = GuiTextModel.new('Supercalifragilisticoespialidoso|1>Test|2')
	var text2 = GuiTextModel.new('Player>Attack|1>Constitution|1>Dexterity|1>Wisdom|1>Money|9999')
	
	menu1.buttons.push_back(button1)
	menu1.buttons.push_back(button2)
	menu1.buttons.push_back(button3)
	menu1.buttons.push_back(button4)
	
	menu2.text = text1
	menu2.buttons.push_back(button5)
	
	menu3.text = text2
	menu3.foreground = false
	
	Signals.emit_signal("guiOpenWindow", menu1, Vector2(100, 100))
	Signals.emit_signal("guiOpenWindow", menu3, Vector2(5, 5))


func handleInput(event : InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		Signals.emit_signal("guiUp")
	elif event.is_action_pressed("ui_down"):
		Signals.emit_signal("guiDown")
	elif event.is_action_pressed("ui_left"):
		Signals.emit_signal("guiLeft")
	elif event.is_action_pressed("ui_right"):
		Signals.emit_signal("guiRight")
	elif event.is_action_pressed("ui_accept"):
		Signals.emit_signal("guiSelect")
	elif event.is_action_pressed("ui_cancel"):
		Signals.emit_signal("guiCancel")
	elif event.is_action_pressed("ui_home"):
		Signals.emit_signal("guiCloseWindow")
	
	if WindowManager.windowQueue.empty():
		next = GameManager.getState(Enums.States.IDLE)

