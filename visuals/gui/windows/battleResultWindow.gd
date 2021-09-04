class_name BattleResultWindow
extends GuiWindowModel


# TODO build a table
func _init(battleResult : BattleResult) -> void:
	text = GuiTextModel.new('TODO')
	
	buttons.append_array([GuiButtonModel.new('Close', Enums.GuiAction.CONFIRM)])
	
	position = Vector2(
		OverlayManager.windowSize().x * 0.5,
		OverlayManager.windowSize().y * 0.5
	)


func windowConfirmed() -> void:
	Signals.emit_signal("battleEnded")

