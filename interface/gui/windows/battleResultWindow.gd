class_name BattleResultWindow
extends GuiWindow


# TODO build a table
func _init(battleResult : BattleResult) -> void:
	widgets.append(GuiTextWidget.new('TODO'))
	
	widgets.append_array([GuiButtonWidget.new('Close', Enums.GuiAction.CONFIRM)])
	
	position = Vector2(
		OverlayManager.windowSize().x * 0.5,
		OverlayManager.windowSize().y * 0.5
	)


func windowConfirmed() -> void:
	Signals.emit_signal("battleEnded")

