extends CenterContainer

var list : Array = []

onready var optMove : OptionButton = $panel/grid/optMove
onready var optFact : OptionButton = $panel/grid/optFact


func _ready() -> void:
	loadFacts()
	loadMoves()


func loadFacts() -> void:
	optFact.clear()
	for fact in Enums.Fact.keys():
		optFact.add_item(fact)
		


func loadMoves() -> void:
	list = Persistence.listEntities(Enums.EntityType.MOVE)
	
	optMove.clear()
	for move in list:
		optMove.add_item(move)

