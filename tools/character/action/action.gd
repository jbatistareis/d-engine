extends PanelContainer

var action : Dictionary = DefaultValues.actionBase


func _enter_tree() -> void:
	$grid/lblAcFactData.text = Enums.Fact.keys()[action.fact]
	$grid/lnkActMoveData.text = action.moveShortName



func _on_lnkActMoveData_pressed():
	EditorSignals.emit_signal("selectedMove", action.moveShortName)

