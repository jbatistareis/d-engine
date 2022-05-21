class_name GuiMoveButtonWidget
extends GuiButtonWidget

const LABEL : String = '[  %s  ]  [  %0.2fs / %0.2fs  ]\n%s'


func _init(move : Move).(LABEL % [move.name, move.cdPre * GameParameters.GCD, move.cdPos * GameParameters.GCD, move.description], Enums.GuiAction.CONFIRM, move, 'move') -> void:
	pass


func action() -> void:
	if !disabled:
		Signals.emit_signal("guiConfirm", self)

