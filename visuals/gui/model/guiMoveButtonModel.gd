class_name GuiMoveButtonModel
extends GuiButtonModel

const LABEL : String = '[  %s  ]\nT: %ds / %ds\n%s'


func _init(move : Move).(LABEL % [move.name, move.cdPre, move.cdPost, move.description], Enums.GuiAction.CONFIRM, move, 'move') -> void:
	pass


func action() -> void:
	if !disabled:
		Signals.emit_signal("guiConfirm", self)

