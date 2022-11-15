extends PanelContainer

var action : Dictionary = DefaultValues.actionBase
var index : int setget setIndex

func _enter_tree() -> void:
	$container/grid/lblAcSelfData.text = Enums.Fact.keys()[action.self]
	$container/grid/lblAcTargetData.text = Enums.Fact.keys()[action.target]
	$container/grid/lnkActMoveData.text = action.moveShortName


func setIndex(value : int) -> void:
	$container/lblPosition.text %= value


func _on_lnkActMoveData_pressed():
	EditorSignals.emit_signal("selectedMove", action.moveShortName)

