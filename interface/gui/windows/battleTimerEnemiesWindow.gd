class_name BattleTimerEnemiesWindow
extends GuiWindow

const ENEMY_ORDER : Array = [4, 2, 0, 1, 3]


func _init(enemies : Array) -> void:
	type = Enums.GuiWindowType.PERMANENT
	
	for i in ENEMY_ORDER:
		if (i < enemies.size()) && (enemies[i] != null):
			widgets.append(GuiCommandProgressWidget.new(enemies[i]))

