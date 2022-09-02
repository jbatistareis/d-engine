extends CenterContainer

var moveList : Array = []
var actionDict : Dictionary setget setActionDict

onready var optSelf : OptionButton = $panel/grid/optSelf
onready var optTarget : OptionButton = $panel/grid/optTarget
onready var optMove : OptionButton = $panel/grid/optMove


func _ready() -> void:
	loadFacts()
	loadMoves()


func setActionDict(value : Dictionary) -> void:
	actionDict = value
	
	optSelf.select(actionDict.self)
	optTarget.select(actionDict.target)
	optMove.select(moveList.find(actionDict.moveShortName))


func loadFacts() -> void:
	optSelf.clear()
	optTarget.clear()
	
	for fact in Enums.Fact.keys():
		optSelf.add_item(fact)
		optTarget.add_item(fact)


func loadMoves() -> void:
	moveList = Persistence.listEntities(Enums.EntityType.MOVE)
	
	optMove.clear()
	for move in moveList:
		optMove.add_item(move)


func _on_optSelf_item_selected(index):
	actionDict.self = index


func _on_optTarget_item_selected(index):
	actionDict.target = index


func _on_optMove_item_selected(index):
	actionDict.moveShortName = optMove.get_item_text(index)


func _on_btnDelete_pressed():
	queue_free()


func _on_btnUp_pressed():
	get_parent().reorderUp(self)


func _on_btnDown_pressed():
	get_parent().reorderDown(self)

