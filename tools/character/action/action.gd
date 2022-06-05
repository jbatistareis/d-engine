extends PanelContainer


func _init() -> void:
	# action : Dictionary
	pass


func _ready():
	var action = DefaultValues.actionBase
	$grid/lblAcFactData.text = Enums.Fact.keys()[action.fact]
	$grid/lnkActMoveData.text = action.moveShortName

