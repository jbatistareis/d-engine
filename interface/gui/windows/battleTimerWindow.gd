class_name BattleTimerWindow
extends GuiWindow


func _init(players : Array, enemies : Array) -> void:
	type = Enums.GuiWindowType.BACKGROUND
	
	for player in players:
		widgets.append(GuiCommandProgressWidget.new(player))
	
	for enemy in enemies:
		widgets.append(GuiCommandProgressWidget.new(enemy))

