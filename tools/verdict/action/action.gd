extends CenterContainer

var moveList : Array = []
var actionDict : Dictionary setget setActionDict

onready var optFact : OptionButton = $panel/grid/optFact
onready var optMove : OptionButton = $panel/grid/optMove


func _ready() -> void:
	loadFacts()
	loadMoves()


func setActionDict(value : Dictionary) -> void:
	actionDict = value
	
	optFact.select(actionDict.fact)
	optMove.select(moveList.find(actionDict.moveShortName))


func loadFacts() -> void:
	optFact.clear()
	
	for fact in Enums.Fact.keys():
		optFact.add_item(fact)


func loadMoves() -> void:
	moveList = Persistence.listEntities(Enums.EntityType.MOVE)
	
	optMove.clear()
	for move in moveList:
		optMove.add_item(move)


func _on_optFact_item_selected(index):
	actionDict.fact = index


func _on_optMove_item_selected(index):
	actionDict.moveShortName = optMove.get_item_text(index)


func _on_btnDelete_pressed():
	queue_free()


func _on_btnUp_pressed():
	get_parent().reorderUp(self)


func _on_btnDown_pressed():
	get_parent().reorderDown(self)

