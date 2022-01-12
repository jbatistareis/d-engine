class_name BattleCursorWindow
extends GuiWindow


func _init(name : String, position : Vector2) -> void:
	widgets.append_array([
		GuiTextWidget.new(name)
	])
	
	self.position = position

