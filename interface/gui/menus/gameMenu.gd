class_name GameMenu
extends GuiWindow


func _init() -> void:
	widgets.append_array([
		GuiButtonWidget.new('Action ', Enums.GuiAction.CONFIRM, true),
		GuiButtonWidget.new('Map   >', Enums.GuiAction.NEW_WINDOW, MapWindow.new()),
		GuiButtonWidget.new('Items >', Enums.GuiAction.NEW_WINDOW, ItemsWindow.new()),
		GuiButtonWidget.new('Equip >', Enums.GuiAction.NEW_WINDOW, EquipmentWindow.new()),
		GuiButtonWidget.new('Moves >', Enums.GuiAction.NEW_WINDOW, MovesWindow.new()),
		GuiButtonWidget.new('Conf  >', Enums.GuiAction.NEW_WINDOW, OptionsWindow.new()),
		GuiButtonWidget.new('< Close')
	])
	
	position = Vector2(
		GuiOverlayManager.windowSize().x * 0.25,
		GuiOverlayManager.windowSize().y * 0.3
	)


func windowConfirmed() -> void:
	pass

