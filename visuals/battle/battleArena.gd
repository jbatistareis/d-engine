extends Spatial


func _ready() -> void:
	Signals.connect("battleStarted", self, "setup")
	Signals.connect("battleEnded", self, "end")
	Signals.connect("askedPlayerBattleInput", self, "showPlayerMenu")


func setup(players : Array, enemies : Array) -> void:
	Signals.emit_signal("battleScreenSetUp")


# TODO
func end(loot) -> void:
	pass


func showPlayerMenu(player : Character) -> void:
	pass

