extends Spatial


func _ready() -> void:
	Signals.connect("setupBattleScreen", self, "setup")
	Signals.connect("battleEnded", self, "finish")
	Signals.connect("askedPlayerBattleInput", self, "showPlayerMenu")
	Signals.connect("showBattleResult", self, "showBattleResult")


func setup(players : Array, enemies : Array) -> void:
	Signals.emit_signal("battleScreenReady")


func finish() -> void:
	pass


func showPlayerMenu(player : Character) -> void:
	Signals.emit_signal("guiOpenWindow", BattleMenu.new(player))


# TODO
func showBattleResult(players : Array, battleResult : BattleResult) -> void:
	for player in players:
		player.gainExperience(battleResult.experience)
	
	Signals.emit_signal("guiOpenWindow", BattleResultWindow.new(battleResult))

