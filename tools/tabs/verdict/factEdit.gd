extends VBoxContainer

const _POSITION_TEXT : String = "#%02d"

var fact : Dictionary = DefaultValues.actionBase
var facts : Array= Enums.Fact.keys()
var moves : Array = []

var factPosition : int :
	set(value):
		$data/lblPosition.text = _POSITION_TEXT % value


func _ready() -> void:
	moves = Persistence.listEntities(Enums.EntityType.MOVE)
	
	for fact in facts:
		$data/grid/optOwn.add_item(fact)
		$data/grid/optTarget.add_item(fact)
	
	for move in moves:
		$data/grid/optMoves.add_item(move)
	
	$data/grid/optOwn.select(fact.own)
	$data/grid/optTarget.select(fact.target)
	$data/grid/optMoves.select(moves.find(fact.moveShortName))


func _on_opt_own_item_selected(index: int) -> void:
	fact.own = index


func _on_opt_target_item_selected(index: int) -> void:
	fact.target = index


func _on_opt_moves_item_selected(index: int) -> void:
	fact.moveShortName = moves[index]


func _on_btn_up_pressed() -> void:
	ToolSignals.factMovedUp.emit(self)


func _on_btn_down_pressed() -> void:
	ToolSignals.factMovedDown.emit(self)


func _on_btn_delete_pressed() -> void:
	ToolSignals.factRemoved.emit(self)

