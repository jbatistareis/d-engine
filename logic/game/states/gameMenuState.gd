class_name GameMenuState
extends State


func _init() -> void:
	# TODO create a proper class
	var menu1 = GuiWindowModel.new()
	var menu2 = GuiWindowModel.new()
	
	var button1 = GuiButtonModel.new()
	var button2 = GuiButtonModel.new()
	var button3 = GuiButtonModel.new()
	var button4 = GuiButtonModel.new()
	
	var button5 = GuiButtonModel.new()
	
	var text1 = GuiTextModel.new()
	
	text1.text = 'Supercalifragilisticoespialidoso|1>Test|2'
	
	button1.action = Enums.GuiAction.NEW_WINDOW
	button1.newWindow = menu2
	
	button1.text = 'TEST 1'
	button2.text = 'TEST 2'
	button3.text = 'TEST 3'
	button4.text = 'TEST 4'
	
	button5.text = '< Back'
	
	menu1.buttons.push_back(button1)
	menu1.buttons.push_back(button2)
	menu1.buttons.push_back(button3)
	menu1.buttons.push_back(button4)
	menu1.position = Vector2(100, 100)
	
	menu2.text = text1
	menu2.buttons.push_back(button5)
	
	Signals.emit_signal("guiOpenWindow", menu1)


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

