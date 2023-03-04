extends HBoxContainer

const _POSITION_TEXT : String = "#%02d"

var factPosition : int :
	set(value):
		$lblPosition.text = _POSITION_TEXT % value

var fact : Dictionary :
	set(value):
		$grid/lblOwnValue.text = Enums.Fact.keys()[value.own]
		$grid/lblTargetValue.text = Enums.Fact.keys()[value.target]
		$grid/lblMoveValue.text = value.moveShortName


func _on_lbl_move_value_pressed() -> void:
	ToolSignals.selectedMove.emit($grid/lblMoveValue.text)

