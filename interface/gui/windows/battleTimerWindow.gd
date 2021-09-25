class_name BattleTimerWindow
extends GuiWindow

const ENEMY_ORDER : Array = [4, 2, 0, 1, 3]


func _init(players : Array, enemies : Array) -> void:
	type = Enums.GuiWindowType.BACKGROUND
	
	for player in players:
		widgets.append(GuiCommandProgressWidget.new(player))
	
	for i in ENEMY_ORDER:
		if (i < enemies.size()) && (enemies[i] != null):
			widgets.append(GuiCommandProgressWidget.new(enemies[i]))

