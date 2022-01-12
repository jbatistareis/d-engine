class_name BattleResultWindow
extends GuiWindow


# TODO build a table
func _init(battleResult : BattleResult) -> void:
	widgets.append_array([
		GuiTextWidget.new('TODO Battle Result'),
		GuiButtonWidget.new('Close', Enums.GuiAction.CONFIRM)
	])
	
	position = Vector2(
		GuiOverlayManager.windowSize().x * 0.5,
		GuiOverlayManager.windowSize().y * 0.5
	)


func windowConfirmed() -> void:
	Signals.emit_signal("battleEnded")

