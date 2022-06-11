class_name ItemsWindow
extends GuiWindow

var character


func _init(character) -> void:
	self.character = character
	
	widgets.append_array([
		GuiTextWidget.new('TODO Items'),
		GuiButtonWidget.new('Close', Enums.GuiAction.CONFIRM)
	])
	
	position = GuiOverlayManager.currentSize * 0.5


func windowConfirmed() -> void:
	pass

