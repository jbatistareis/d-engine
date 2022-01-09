class_name ItemsWindow
extends GuiWindow

var character


func _init(character) -> void:
	self.character = character
	
	widgets.append_array([
		GuiTextWidget.new('TODO Items'),
		GuiButtonWidget.new('Close', Enums.GuiAction.CONFIRM)
	])
	
	position = Vector2(
		GuiOverlayManager.windowSize().x * 0.5,
		GuiOverlayManager.windowSize().y * 0.5
	)


func windowConfirmed() -> void:
	pass

